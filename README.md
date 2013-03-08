# SecurityReleasePractice

Security is hard. One of the skills any OSS maintainer needs is how to do
releases, and security releases are a special kind of release that needs
special git-fu to make it work.

This repository exists so that you can practice this particular skill.

## The problem

This gem provides a binary, `omg_insecure`, which has a security issue.
Basically, the `super_secure_calculation` method converts user input to a
symbol. Since Ruby does not garbage collect symbols, the longer you run
`omg_insecure`, the more memory it will use, until your computer runs out of
memory and the box grinds to a halt. Seems bad.

So, just fix `super_secure_calculation` and release, right? Well, here's the
problem: the last release of `security_release_practice` was 1.0.0. Since
then, we've had a new feature, and a backwards incompatible change with
`super_secure_calculation`. You can see the two commits
[here](https://github.com/steveklabnik/security_release_practice/compare/v1.0.0...master).

This is a problem: if we fix the issue and release, people who are relying on
the `+ 5` behavior can't upgrade: they'll now be getting `+ 6`. Also, the new
feature (`another_new_calculation`) may have conflicts or weirdness with their
code. That's bad! So what we really want is a relase that's exactly the
same as 1.0.0, but with the security fix applied.

Let's give that a shot.

## The answer

If you think you're good with `git`, you can try this out right now. If you've
done it correctly, you should end up with the following:

1. A 1-0-stable branch
2. That branch should contain a new commit that fixes the issue
3. That branch should contain a new tag, v1.0.1 that fixes the issue
4. Master should have a backported version of the commit in #2.

The repository [as it
exists](https://github.com/steveklabnik/security_release_practice) has all of
this stuff, so check your work against it!

## Practice!

If you _don't_ know how to do this, or you get stuck, you've come to the
right place! Here's what you need to do:

First, some setup work. Fork the repository and clone it down. Or, just clone
mine, whatever:

```
$ git clone https://github.com/steveklabink/security_release_practice
$ cd security_release_practice
```

Next, since this repository has the backported fix involved, you need
to remove that commit:

```
$ git reset --hard HEAD~1
```

This basically backs our branch out by one commit. Now we're ready to go.

The first thing in actually doing the work is to check out the tag that
we last released from. In our case, that tag is `v1.0.0`. So let's do that
now:

```
$ git checkout v1.0.0
```

`git` will give you a message:

```
Note: checking out 'v1.0.0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at 47a8bfb... Initial release.
```

We want to take `git`'s advice: let's make a new branch. Since it's going to
be all our fixes for `1.0.x`, let's call it `1-0-stable`:

```
git checkout -b 1-0-stable
```

Now we have our stable branch. Awesome! Master is the work that will go into
`1.1.x`, and this branch will be for `1.0.x`.

Next, we need to fix our bug. You need to remove this one line:

```diff
--- a/lib/security_release_practice.rb
+++ b/lib/security_release_practice.rb
@@ -3,7 +3,7 @@ require "security_release_practice/version"
 module SecurityReleasePractice
   def super_secure_calculation(input)
-     input.to_sym
     input.to_i + 5
   end

   def another_new_calculation(input)
```

We don't even use that symbol, what a waste! Commit this, with a descriptive
message. You can [find mine here](https://github.com/steveklabnik/security_release_practice/commit/168d5f756221ed43b0c67569ac82429f0b391504).
Note the first few characters of the hash: mine is `168d5f756221`.

Next, we need to release. Go ahead and increment the version number in
`lib/security_release_practice/version.rb`, commit that, and then try
`rake install`. Everything should work. Great! If you were actually releasing
this gem, you'd be running `rake release` instead, but it's my gem, not
yours. 😗

Okay, now we've released a version with our fix, but `master` still has a
vulnerability: we need to port the fix. So let's go back to master:

```
$ git checkout master
```

And then cherry-pick our fix over:

```
$ git cherry-pick 168d5f756221
```

There will be a conflict. The diff is a little weird, such is life. Go ahead
and fix the conflict, then commit:

```
$ git commit
```

And you're done!

### Other considerations

If we had a CHANGELOG, we'd need to udpate that as appropriate, including
creating new sections for our `1.0.1` release.

Sometimes it's easier to fix things on master first, then backport to the new
branch. I prefer to do it the way I showed here.

You should probably try to get as many people to know that you've fixed the
bug. Tweet, blog, rabble-rouse, and possibly [post to the ruby-security-ann
mailing list](https://groups.google.com/forum/#!forum/ruby-security-ann), which
was created to help Rubyists know about security releases of their gems.

If your gem is really widely used, you may want to actually register a CVE.
You can find information on this process [here](https://groups.google.com/forum/#!forum/ruby-security-ann).
