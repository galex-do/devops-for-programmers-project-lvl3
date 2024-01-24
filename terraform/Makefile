GPG_KEY := 3F6A780F9054BCC8F9200B0B818D2806540C4B57

decrypt-backend-data:
	sops --decrypt --pgp ${GPG_KEY} secrets/backend.enc.tfvars > backend.tfvars.decrypted

init:
	terraform init -backend-config=backend.tfvars.decrypted

format:
	terraform fmt
	cd modules && terraform fmt -recursive

encrypt-sa-data:
	sops --encrypt --in-place --pgp ${GPG_KEY} secrets/secret.enc.json
	sops --encrypt --in-place --pgp ${GPG_KEY} secrets/key.enc.json

encrypt-backend-data:
	sops --encrypt --pgp ${GPG_KEY} backend.tfvars.decrypted > secrets/backend.enc.tfvars

decrypt-sa-data:
	sops --decrypt --pgp ${GPG_KEY} secrets/secret.enc.json > secrets/secret.json.decrypted
	sops --decrypt --pgp ${GPG_KEY} secrets/key.enc.json > secrets/key.json.decrypted


apply:
	terraform apply

destroy:
	terraform destroy

output:
	terraform output
