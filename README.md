# awx-ansible-terraform-aws

Projeto AWX na AWS provisionado com Terraform (VPC, SecurityGroup e EC2) e Ansible

## Requisitos

Chave IAM com permissão de criar VPC, SecurityGroup e EC2

## Ajustar para seu ambiente AWS

```python
vi aws-terraform/variables.tf 
```

## Usage

```python
ssh-agent zsh
ssh-add your_key_pair.pem
ansible-galaxy install -r req.yml
ansible-playbook -i hosts main.yml
```

## Destroy

```go
cd aws-terraform
terraform destroy --auto-approve
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
