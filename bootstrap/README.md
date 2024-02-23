# Doorway Bootstrap

Builds out the pipeline infrastructure for Doorway. 
Should allow you to build out in any region and allow for somewhat
flexible naming to still be opinionated about doorway environment setup while
being flexible enough so that you don't overwrite the main production pipelines 
when youre just looking to futz with something. 




## Getting Started

1. Clone this repo
2. cd to this directory
3. terraform init
4. terraform plan
5. terraform apply
6. A bootstrap [CodeBuild](https://aws.amazon.com/codebuild/) project gets created in your AWS account. 
7. Running that should create your new CI/CD pipeline for doorway!



### Prerequisites

- You will need a fair amount of administrative rights in your AWS account to use this. 
    - In the case of the BAHFA AWS account you will likely need to be in the BAHFA-Administrator group. 
    - Theoretically this should work with other AWS accounts with minor modifications but we'll see. 




