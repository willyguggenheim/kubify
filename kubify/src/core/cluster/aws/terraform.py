import subprocess
import json
import boto3

eks_cli = boto3.client("eks")


def subprocess_cmd(command):
    print("cmd to be executed = " + str(command))
    output = subprocess.check_output(command, shell=True)
    # print(output)
    return output


def get_clusters():
    # return json.loads(subprocess_cmd("make eks-list-json"))
    return eks_cli.list_clusters()


def print_clusters(clusters):
    for i in clusters:
        print(
            "Cluster name == {name} and region == {region}".format(
                name=i["name"], region=i["region"]
            )
        )


def create_list_of_cluster_name():
    cluster_name_list = []
    clusters = get_clusters()
    for i in clusters:
        cluster_name_list.append(i["name"])
    return cluster_name_list


def check_cluster(name, region):
    clusters = get_clusters()
    # print(clusters)
    f = True
    for i in clusters:
        if name == i["name"] and region == i["region"]:
            # print("Cluster is there change name or region to proceed forward")
            # return False
            f = False
        else:
            # return True
            f = True
    return f


def create_cluster():

    cluster_name = input("Enter cluster name : ")
    cluster_region = input("Enter cluster region : ")

    if check_cluster(cluster_name, cluster_region) == False:

        print("Cluster is there change name or region to proceed forward")

    else:
        # nodes = input("Enter number of nodes : ")
        # minNodes = input("Enter minimum number of nodes in cluster : ")
        # maxNodes = input("Enter maximum number of nodes in cluster : ")
        # path = input("enter path for kubeconfig file : ")
        command = "make cloud aws"

        print(command)
        output = subprocess_cmd(command)
        print(output)


print("1) for list of clusters ")
print("2) for create cluster ")
user_input = input("select operation ")
print(type(user_input))
if user_input == 1:
    clusters = get_clusters()
    print_clusters(clusters)

elif user_input == 2:
    create_cluster()


"""
cluster_name = input("Enter cluster name : ")
cluster_region = input("Enter cluster region : ")
out = check_cluster(cluster_name, cluster_region)
print(out)
"""
