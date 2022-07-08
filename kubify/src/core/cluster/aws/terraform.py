import subprocess
import json
import boto3

eks_cli = boto3.client("eks")


def subprocess_cmd(command):
    print("cmd to be executed = " + str(command))
    output = subprocess.check_output(command, shell=True)
    # print(output)
    return output


def getClusters():
    # return json.loads(subprocess_cmd("make eks-list-json"))
    return eks_cli.list_clusters()


def print_clusters(clusters):
    for i in clusters:
        print(
            "Cluster name == {name} and region == {region}".format(
                name=i["name"], region=i["region"]
            )
        )


def createListOfClusterName():
    clusterNameList = []
    clusters = getClusters()
    for i in clusters:
        clusterNameList.append(i["name"])
    return clusterNameList


def checkCluster(name, region):
    clusters = getClusters()
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


def createCluster():

    clusterName = input("Enter cluster name : ")
    clusterRegion = input("Enter cluster region : ")

    if checkCluster(clusterName, clusterRegion) == False:

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
    clusters = getClusters()
    print_clusters(clusters)

elif user_input == 2:
    createCluster()


"""
clusterName = input("Enter cluster name : ")
clusterRegion = input("Enter cluster region : ")
out = checkCluster(clusterName, clusterRegion)
print(out)
"""
