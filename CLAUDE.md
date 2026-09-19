# CLAUDE.md

@CONTRIBUTING.md

## Notes for Claude

- Open pull requests and stop there, the maintainer reviews and merges them. Do not merge unless explicitly asked.
- Run the checks from CONTRIBUTING.md before pushing, and `git add` new files first, `pre-commit --all-files` skips
  untracked files.
- Never put real financial data, credentials or personal details into the repository, commits, pull requests or issues.
  Ledgers used for testing the image are synthetic.
- Build the image and run it before opening a pull request that changes the `Dockerfile` or `requirements.txt`, and say
  in the description what was tested. Compare `pip freeze` of the image before and after to see what a change really
  does.
- Keep pull request descriptions factual: the problem, the change, how it was verified (including what could not be
  verified before merging, e.g. the publishing steps).
