module "aws-eks-dev-failover" {
  source          = "../../mod_eks"
  cluster_name    = "aws-eks-dev"
  subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  vpc_id		  = "vpc-1234556abcdef"
}
