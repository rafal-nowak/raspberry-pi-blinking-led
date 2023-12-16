Install tools:

```
sudo apt-get update
sudo apt-get install jq
```

```
sudo apt-get update
sudo apt-get install yq
```

Run the Update Script:

Make sure to make the script executable by running 

```
chmod +x update.sh
```


On each device where you want to update your application, run the update.sh script.
This script will pull the latest image, stop the existing container, and start a new container with the latest image.

```bash
./update.sh
```

Automate Updates:

To automate the update process, you can set up a scheduled task or cron job on each device to run the update.sh script at specific intervals (e.g., daily, weekly).
This way, your devices will regularly check for updates and apply them automatically.

For example, to schedule the update to run daily at midnight, you can create a cron job by running:

```
crontab -e
```

Then, add the following line to the crontab file:

```
0 0 * * * /path/to/update.sh
```

Replace /path/to/update.sh with the actual path to your update.sh script.


Add the following line to the crontab file to run your script every 5 minutes:

```
*/5 * * * * /path/to/your/script.sh
```
