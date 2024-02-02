#!/bin/bash

INFRA_FAIL_EXIT_CODE=100
K8S_FAIL_EXIT_CODE=101

EXTRA_AKS_ADMIN_GROUPS="[\"${AZ_AD_DEVOPS_GROUP_ID}\"]"

function echo_performing {
    echo ">>>>>>>>>>> Performing $1 > $2"
}

function run_tf_for_infra {
    echo_performing $1 "infrastructure"
    terraform -chdir=infra $1 \
        -var="extra_aks_admin_groups=${EXTRA_AKS_ADMIN_GROUPS}"
    if [ $? -ne 0 ]; then exit $INFRA_FAIL_EXIT_CODE; fi
}

function apply_infra {
    run_tf_for_infra apply
}

function destroy_infra {
    run_tf_for_infra destroy
}

function run_tf_for_k8s {
    echo_performing $1 kubernetes
    terraform -chdir=k8s $1 \
        -var="k8s_cluster_host=${k8s_cluster_host}" \
        -var="k8s_cluster_ca_cert=${k8s_cluster_ca_cert}" \
        -var="azure_tenant_id=${azure_tenant_id}" \
        -var="aks_aad_id=${aks_aad_id}" \
        -var="k8s_sp_id=${k8s_sp_id}" \
        -var="k8s_sp_secret=${k8s_sp_secret}" \
        -var="loadbalancer_ip=${aks_public_ip}" \
        -var="istio_node_madefor_label_value=${istio_madefor_node_label_value}"
    if [ $? -ne 0 ]; then exit $K8S_FAIL_EXIT_CODE; fi
}

function apply_k8s {
    run_tf_for_k8s apply
}   

function destroy_k8s {
    run_tf_for_k8s destroy
}

function get_terraform_output {
    terraform -chdir=$1 output -raw $2
}

function export_infra_outputs {
    export k8s_cluster_host=$(get_terraform_output infra aks_cluster_host)
    export k8s_cluster_ca_cert=$(get_terraform_output infra aks_cluster_ca_cert)
    export azure_tenant_id=$(get_terraform_output infra tenant_id)
    export aks_aad_id=$(get_terraform_output infra aks_aad_client_id)
    export k8s_sp_id=$(get_terraform_output infra aks_admin_sp_id)
    export k8s_sp_secret=$(get_terraform_output infra aks_admin_sp_secret)
    export aks_public_ip=$(get_terraform_output infra aks_public_ip)
    export istio_madefor_node_label_value=$(get_terraform_output infra istio_madefor_node_label_value)
}

function create {
    apply_infra
    export_infra_outputs
    apply_k8s
}

function destroy {
    export_infra_outputs
    destroy_k8s
    destroy_infra
}

function run_terraform_command_for_all_projects {
    echo_performing $1 "infrastructure"
    terraform -chdir=infra $1
    echo_performing $1 "kubernetes"
    terraform -chdir=k8s $1
}

if [ "$1" = 'apply' ]
then
    create
elif [ "$1" = 'destroy' ]
then
    destroy
elif [ "$1" = 'format' ]
then
    run_terraform_command_for_all_projects fmt
elif [ "$1" = 'validate' ]
then
    run_terraform_command_for_all_projects validate
elif [ "$1" = 'init' ]
then
    run_terraform_command_for_all_projects init
else
    echo "USAGE: $0 <ACTION>"
    echo -e "ACTION is one of:"
    echo -e "\tapply\tperforms terraform apply and the necessary output/input handling for each project"
    echo -e "\tdestroy\tperforms all the necessary output/input handling then terraform destroy for each project"
    echo -e "\tformat\truns terraform fmt to all projects"
    echo -e "\tvalidate\truns terraform validate for all projects"
    echo -e "\tinit\truns terraform init for all projects"
fi