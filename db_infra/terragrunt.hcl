generate "backend" {
      path="backend.tf"
      if_exists="overwrite"
      contents= <<EOF
      terraform {
      backend "s3" {

      }
      }
      EOF
}
remote_state {
  backend = "s3"
  config = {
    bucket = "${get_env("TF_STATE_BUCKET")}/${get_env("ENVIRONMENT")}"
    region="us-west-2"
    key=get_env("WORKSPACE")
    kms_key_id=get_env("KMS_KEY")
    encrypt=true

  }
}