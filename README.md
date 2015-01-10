# Resque - Quit vs Sigterm

This is just a tiny of example of what happens to a Resque queue when you send a SIGTERM vs QUIT to a worker.

When you SIGTERM, the worker stops in the middle of the job and the process dies immediately.
When you QUIT the worker will finish its work and the the process will end.

As a failover mechanism, in <code>initializer.rb</code> there is code that will check the Resque fail queue for any failures that occurred with the <code>Resque::DirtyExit</code> exception, re-enqeue the job, and then remove it from the fail queue.

# How to use
First you need to make sure you have redis running
<pre><code>sudo apt-get install redis-server</code></pre>

Then You can run
<code> bundle install </code>
to install the necessary gems required for this app: Rake and Resque (if you don't have them already)

## Commands
Inside this app is a command line app.rb in which you can start Resque, enqueue a test job, and then send either a SIGTERM or QUIT to the job, so you can see the effects of both.

## Usage
<pre><code>Usage: ruby app.rb [options]
    -e, --enqueue                    Enqueue a Worker Job
    -d N                             Delay N seconds before Quiting or Sigterming.
    -s, --sigterm                    Send a SIGTERM to Resque
    -r, --resque                     Start resque
    -q, --quit                       Send a QUIT signal to Resque
</code></pre>

## How to Test
You will need two terminals open to test this because Resque blocks.

In the first terminal, run:
<code>ruby app.rb -r</code>

You will see resque start up and then wait for a job.

In the second terminal, enqueue a job:
<code>ruby app.rb -e</code>

You will now see in the first terminal (where Resque is running) the output from the worker that is running the job. It will look something like this:
<pre><code> Starting
...Working
...Working
...</code></pre>


The worker sleeps every second and then outputs "...Working" for 15 seconds.  Enough time for you to go to your other console and either SIGTERM the worker or QUIT it.

## SIGTERM Worker
Be sure you have Resque running already in another terminal. This will do absolutely nothing otherwise.
<code>ruby app.rb -s</code>
Once you run this command you will notice that the worker stops mid-process and the entire resque process dies bringing you back to a shell prompt.  If you want to test further you will need to re-run:
<code>ruby app.rb -r</code>

## QUIT Worker
Be sure you have Resque running already in another terminal. This will do absolutely nothing otherwise.
<code>ruby app.rb -q</code>
Once you run this command, you will notice that the worker does not stop but will continue to finish its job.  When the job is complete, then Resque will die. If you want to test further you will need to re-run:
<code>ruby app.rb -r</code>

## Worker Restarts When Resque is restarted
If you SIGTERM'd a worker or even hit CRTL-C to exit Resque *in the middle of a worker processing a job*, when Resque comes back it will search the fail queue for any jobs that failed due to Resque::DirtyExit exceptions, requeue them for work, and remove them from the fail queue. This way you can ensure that jobs can be replayed if your worker dies in the middle of a job.

