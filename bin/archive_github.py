#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import requests
import argparse
import getpass
from datetime import datetime
from multiprocessing.dummy import Pool
from queue import Queue
from collections import namedtuple
from git import Repo


parser = argparse.ArgumentParser()
parser.add_argument("-u", "--username", help="github username")
parser.add_argument("-p", "--password", help="github password")
parser.add_argument("-o", "--output", help="output directory")
parser.add_argument("-i", "--ignore-exception", action='store_true', help="continue when exception")
parser.add_argument("-r", "--requeue", action='store_true', help="requeue when exception")
parser.add_argument("-d", "--debug", action='store_true', help="debug mode")
args = parser.parse_args()
if args.username is None:
    args.username = input("Username: ")
if args.password is None:
    args.password = getpass.getpass()


RED        ='\033[0;31m'
GREEN      ='\033[0;32m'
NC         ='\033[0m' 
OUTPUT_DIR = args.output or 'archive_github_{}'.format(args.username)
GitRepo    = namedtuple("GitRepo", ["clone_url", "local_path"])


def dbg(*largs, **kwargs):
    if args.debug:
        print(*largs, **kwargs)


def ensure_dir(d):
    if not os.path.exists(d):
        os.makedirs(d)


def github_gists():
    gists_url = f"https://{args.username}:{args.password}@api.github.com/gists"
    gists     = requests.get(gists_url).json()
    repo_dir  = os.path.join(OUTPUT_DIR, "gists")
    git_repos = [] 
    for gist in gists:
        if 'git_pull_url' in gist:
            git_repo = GitRepo(clone_url=gist['git_pull_url'],
                               local_path=os.path.join(repo_dir, gist['id']))
            dbg(git_repo)
            git_repos.append(git_repo)
    return git_repos


def github_repos():
    repos_url = f"https://{args.username}:{args.password}@api.github.com/user/repos"
    repos     = requests.get(repos_url).json()
    repo_dir  = os.path.join(OUTPUT_DIR, "repositories")
    git_repos = [] 
    for repo in repos:
        if 'clone_url' in repo:
            git_repo = GitRepo(clone_url=repo['clone_url'],
                               local_path=os.path.join(repo_dir, repo['name']))
            dbg(git_repo)
            git_repos.append(git_repo)
    return git_repos


def github_watched_repos():
    repos_url = f"https://{args.username}:{args.password}@api.github.com/user/subscriptions"
    repos     = requests.get(repos_url).json()
    repo_dir  = os.path.join(OUTPUT_DIR, "watched_repositories")
    git_repos = [] 
    for repo in repos:
        if 'clone_url' in repo:
            git_repo = GitRepo(clone_url=repo['clone_url'],
                               local_path=os.path.join(repo_dir, repo['name']))
            dbg(git_repo)
            git_repos.append(git_repo)
    return git_repos


def github_starred_repos():
    repos_url = f"https://{args.username}:{args.password}@api.github.com/user/starred"
    repos     = requests.get(repos_url).json()
    repo_dir  = os.path.join(OUTPUT_DIR, "starred_repositories")
    git_repos = [] 
    for repo in repos:
        if 'clone_url' in repo:
            git_repo = GitRepo(clone_url=repo['clone_url'],
                               local_path=os.path.join(repo_dir, repo['name']))
            dbg(git_repo)
            git_repos.append(git_repo)
    return git_repos




def git_clone_by_py(repo:GitRepo) -> bool :
    dbg(repo)
    prefix = ''
    try:
        if os.path.exists(os.path.join(repo.local_path, ".git")):
            prefix = f"{GREEN}Updating{NC} {repo.clone_url}..."
            print(prefix, flush=True)
            Repo(repo.local_path).remote().pull()
        else:
            prefix=f"{GREEN}Cloning{NC} {repo.clone_url}"
            print(prefix, flush=True)
            def progress(op_code, cur_count, max_count=None, message=''):
                # print('\r' + " "*100, end='', flush=True)
                # print(f'\r{prefix} [{cur_count}/{max_count} {message}]', end='')
                pass
            Repo.clone_from(repo.clone_url, repo.local_path, progress=progress)
    except Exception as e:
        print(f"{prefix} {RED}Failed{NC}")
        if not args.ignore_exception:
            raise e
    print(f"{prefix} {GREEN}OK{NC}")



def git_clone_repos(repos):
    q = Queue()
    list(map(q.put, repos))

    pool = Pool(20)
    pool.map_async(git_clone_by_py, repos)
    pool.close()
    pool.join()
           
            
def main():            
    repos = []
    repos.extend(github_repos())
    repos.extend(github_gists())
    # repos.extend(github_watched_repos())
    # repos.extend(github_starred_repos())
    git_clone_repos(repos)


if __name__ == '__main__':
    main()
