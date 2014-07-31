## How to Contribute

In the spirit of open source software, **everyone** is encouraged to help
improve this project.

### Ways *you* can contribute:

* by installing and testing the software
* by reporting bugs
* by suggesting new features
* by suggesting labels for our issues
* by writing or editing documentation
* by writing test specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues][issue_tracker]
* by reviewing patches
* by [donating to Code for America][donate]

### Reporting a bug or other issue

We use the [GitHub issue tracker][issue_tracker] to track bugs and feature
requests. To submit a bug report or feature request:

1. [Browse][issue_tracker] or [search][issue_search] our issues to make sure
it hasn't already been submitted.

2. When submitting a bug report, it's helpful to include any details that may
be necessary to reproduce the bug, including:

    - a screenshot
    - your operating system (Windows 7, Mac OSX 10.9.2, etc.)
    - your web browser and version (Internet Explorer 9, Chrome 27, etc.)
    - a stack trace of any errors encountered
    - your Ruby version (use `ruby -v` from the command line)

For developers, a bug report should ideally include a pull request with
failing specs.

### Updating the Code? Open a Pull Request

To submit a code change to the project for review by the team:

1. **Setup:** [Install the app][install] on your computer.

2. **Branch:** [Create a topic branch][branch] for the one specific issue
you're addressing.

3. **Write Specs:** Add specs for your unimplemented feature or bug fix in the
`/spec/` directory.

4. **Test to fail:** Run `spring rspec`. If your specs pass, return to **step 3**.
In the spirit of Test-Driven Development, you want to write a failing test
first, then implement the feature or bug fix to make the test pass.

5. **Implement:** Implement your feature or bug fix. Please follow the
[community-driven Ruby Style Guide][style_guide]*.

6. **Test to pass:** Run `script/test` to run the test suite, in addition to style checkers. If your specs fail and/or style offenses are reported, return to **step 5**.

7. **Commit changes:** Add, commit, and push your changes.

8. **Pull request:** [Submit a pull request][pr] to send your changes to this
repository for review.

_*If you use Sublime Text, please make sure to set your tab indentation to 2
spaces. We also highly recommend you use the [TrailingSpaces][trailing_spaces]
plugin and set it to [Trim On Save][trim_on_save]._

[donate]: http://codeforamerica.org/support-us/
[issue_tracker]: https://github.com/codeforamerica/ohana-api/issues
[issue_search]: https://github.com/codeforamerica/ohana-api/search?ref=cmdform&type=Issues
[install]: https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md
[branch]: https://help.github.com/articles/fork-a-repo#create-branches
[style_guide]: https://github.com/bbatsov/ruby-style-guide
[pr]: http://help.github.com/send-pull-requests/
[trailing_spaces]: https://github.com/SublimeText/TrailingSpaces
[trim_on_save]: https://github.com/SublimeText/TrailingSpaces#trim-on-save
