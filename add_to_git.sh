#/bin/bash

find -maxdepth 2 -name "*~" -exec rm -rf {} +

# git clone url
# git pull # update from remote server
# git config credential.helper store # create local copy of user name nad pass

# git pull # for save credentials


# create new branch https://github.com/Kunena/Kunena-Forum/wiki/Create-a-new-branch-with-git-and-manage-branches

git add .  # add folder git add folder/*
git commit -m *
# git commit -m * 20_4_19_new_desing/
git push --repo https://github.com/zgtman/fusion_genes.git
