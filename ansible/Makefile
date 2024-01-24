setup-pipenv: #https://www.buildahomelab.com/2022/04/26/how-to-install-ansible-with-pipenv-pyenv/
	pipenv install
	pipenv install ansible --python 3.10.4
	pipenv shell

list-collections:
	ansible-galaxy list

install-collections:
	ansible-galaxy install -r requirements.yml

play:
	ansible-playbook -i inventory.ini --tags $(ANSIBLE_TAG) --ssh-extra-args "-F ssh-config-hexlet3" playbook.yml

setup:
	make play ANSIBLE_TAG=setup

datadog:
	make play ANSIBLE_TAG=datadog

deploy:
	make play ANSIBLE_TAG=deploy
