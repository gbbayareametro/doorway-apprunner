generate "backend" {
      path="backend.tf"
      if_exists="overwrite"
      contents= <<EOF
      backend "s3" {

      }
      EOF
}
remote_state {
  backend = "s3"
  config = {
    bucket = get_env("TF_STATE_BUCKET")
    region="us-west-2"
    key=get_env("WORKSPACE")
    encrypt=true
    disable_init=true

  }
}