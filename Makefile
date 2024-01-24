import-key:
	gpg --import key.gpg

prepare-project:
	make -C terraform decrypt-backend-data
	make -C ansible install-collections

setup-infra:
	make -C terraform init
	make -C terraform apply

update-infra:
	make -C terraform apply

configure-infra:
	make -C ansible setup
	make -C ansible datadog
	make -C ansible deploy

deploy-service:
	make -C ansible deploy

delete-infra:
	make -C terraform destroy
