# TODO: move to make commands and then call using pymake
# import pymake

import os
import subprocess
import time
import json


def subprocess_cmd(command):
    print("cmd to be executed = " + str(command))
    output = subprocess.check_output(command, shell=True)
    # print(output)
    return output


def getClusters():
    return json.loads(subprocess_cmd("eksctl get cluster -o json"))


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
        nodes = input("Enter number of nodes : ")
        minNodes = input("Enter minimum number of nodes in cluster : ")
        maxNodes = input("Enter maximum number of nodes in cluster : ")
        path = input("enter path for kubeconfig file : ")
        command = "eksctl create cluster --name {clusterName} --version 1.13 --nodegroup-name standard-workers --node-type t3.medium --nodes {nodes} --nodes-min {minNodes} --nodes-max {maxNodes} --node-ami auto --kubeconfig {path}/kubeconfig".format(
            clusterName=clusterName,
            nodes=nodes,
            minNodes=minNodes,
            maxNodes=maxNodes,
            path=path,
        )
        print(command)
        output = subprocess_cmd(command)
        print(output)


def deleteCluster():
    f = True
    while f == True:
        clusters = getClusters()
        # for i in clusters:
        #   print("Cluster name == {name} and region == {region}".format(name=i['name'], region=i['region']))
        print_clusters(clusters)
        del_cluster = input("Enter name of cluster to delete (case sensitive) : ")

        if del_cluster in createListOfClusterName():
            command = "eksctl delete cluster {name}".format(name=del_cluster)
            output = subprocess_cmd(command)
            print(json.loads(output))
            f = False
        else:
            print("wrong cluster name, please enter correct name ")


# createCluster()
# deleteCluster()


print("1) for list of clusters ")
print("2) for create cluster ")
print("3) for delete cluster ")
user_input = input("select operation ")
print(type(user_input))
if user_input == 1:
    clusters = getClusters()
    print_clusters(clusters)

elif user_input == 2:
    createCluster()

else:
    deleteCluster()


"""
clusterName = input("Enter cluster name : ")
clusterRegion = input("Enter cluster region : ")
out = checkCluster(clusterName, clusterRegion)
print(out)
"""


# create cluster need to find way to add kubeconfig file to location
# sclae up cluster
# scale down cluster
# need BOTO3 to get information related to cluster
