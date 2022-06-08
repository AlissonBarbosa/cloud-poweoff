# Processo de desligamento

- Crie um environment e instale a cli do openstack
- Carregue as credenciais de administrador da cloud
- Rode o script de desligamento

## Caso o script falhe, ou prefira desligar manualmente

Tenha como base a lista de computes:
```shell
(venv) user@host:~$ openstack hypervisor list
```
Para listar as instâncias em cada um dos computes ($compute_name é o nome do compute sem o domínio):
```shell
(venv) user@host:~$ openstack server list --host $compute_name --all-projects
```
Para desligar instância por instância, baseado na lista anterior:
```shell
(venv) user@host:~$ openstack server stop $id_da_instancia
```
Para desligar todas as intâncias de um compute automaticamente, rode o seguinte loop:
```shell
(venv) user@host:~$ for server in $(openstack server list --host c5-compute5 -f value --all-projects | awk -F " " '{ print $1 }'); do openstack server stop $server; done
```
Para acompanhar o desligamento das instâncias em um compute use:
```shell
(venv) user@host:~$ watch openstack server list --host c5-compute5 --all-projects
```

Após todas as instâncias de um compute estarem com o status "shutoff", desligue o compute.
