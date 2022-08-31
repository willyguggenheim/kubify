import git


def git_version():
    repo = git.Repo(search_parent_directories=True)
    sha = repo.head.object.hexsha
    short_sha = repo.git.rev_parse(sha, short=4)
    return short_sha, sha


def git_username():
    return git.util.get_user_id()
