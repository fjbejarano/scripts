#!/bin/bash

# @Author: Francisco J. Bejarano
# @License: GPL v3 https://www.gnu.org/licenses/licenses.html#GPL

# Alternate id_rsa on demand between two users to be able to manage remote ssh access with two different accounts
# You need the keys created and with the correct names for user1 and user2 in rsa format (ssh-keygen)

# Example: 2 github accounts fbejarano and fjbejarano with the pub keys comfigured in github

user1="fbejarano"
user2="fjbejarano"

path="${HOME}/.ssh"

# Use files of your users for user1 and user2 
ssh_key_user1="${user1}_id_rsa"
ssh_key_user2="${user2}_id_rsa"
ssh_pub_user1="${user1}_id_rsa.pub"
ssh_pub_user2="${user2}_id_rsa.pub"

# Change id_rsa private and public keys to default ssh keys of user1 or user2 or list users
case $1 in
	user1)
		if [ ! -f ${path}/${ssh_key_user1} ] ; then
			echo "Key file ${path}/${ssh_key_user1}  not exits. Review your files. Exiting..."
			exit 1
		fi
		mv ${path}/id_rsa ${path}/${ssh_key_user2}
		mv ${path}/id_rsa.pub ${path}/${ssh_pub_user2}
                mv ${path}/${ssh_key_user1} ${path}/id_rsa
		mv ${path}/${ssh_pub_user1} ${path}/id_rsa.pub
	        echo "RSA changed to use the user ${user1}"
	;;
	user2)

		if [ ! -f ${path}/${ssh_key_user2} ] ; then
                        echo "Key file ${path}/${ssh_key_user2}  not exits. Review your files. Exiting..."
                        exit 1
                fi
                mv ${path}/id_rsa ${path}/${ssh_key_user1}
                mv ${path}/id_rsa.pub ${path}/${ssh_pub_user1}
                mv ${path}/${ssh_key_user2} ${path}/id_rsa
                mv ${path}/${ssh_pub_user2} ${path}/id_rsa.pub
	        echo "RSA changed to use the user ${user2}"
	;;
	list)
		echo "user1 is ${user1}"
		echo "user2 is ${user2}"
		exit 0
	;;
	*)
		echo "usage: `basename ${0}` user1|user2|list"
		exit 2
	;;
esac

# Flush keys and add changed rsa to ssh-agent
ssh-add -D 
ssh-add ${path}/id_rsa
