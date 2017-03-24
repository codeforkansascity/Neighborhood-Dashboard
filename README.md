##Welcome
to the KCNeighborhoodStat app project! We're working  to help neighborhoods help themselves by giving them easy access to useful civic open data.
We're ultimately hoping to develop an app that- by providing easier access to civic open data- lets neighborhood
organization and neighbors:

*  **Better understand their neighborhood through data**
*What is my neighborhood- what are its boundaries? How many people live there? How much crime happens here?*

*  **More easily track development and others projects in their neighborhoods**
*Is a new business opening  down the street? Is a building being torn down?*

*  **Make better decisions as a community**
*Do we have a lot of senior citizens that need help with minor home repair?*

*  **Become more effective advocates for their community**
*We need more police patrols and codes inspections- here's the data*

### Civic data: the opportunity

These days, we're seeing a greater availability of civic open data in cities
across the country- Kansas City included! We believe this trend towards more open data is especially good news for
the neighborhoods that make up the fabric of the city. Rich,up-to-date information about crime, development, and demographics is what neighborhoods need to make better decisions and to advocate for themselves more effectively with government agencies and other organizations.

### Civic data: the problem

Unfortunately, even though the data are out there,  its potential power to help neighborhoods isn’t yet realized.
Accessing civic data might mean hours of wading through spreadsheets, then trying to interpret confusing terminology, or having to go through a website that is not easy to use for the average resident or neighborhood leader.
Meanwhile, civic data is usually not presented at the neighborhood-level geography. Right now, for instance, it’s not possible to see the population of a neighborhood or the number of crimes that have occurred there recently.

## That’s why we created KCNeighborhoodStat
*We’re making an application that displays relevant civic open data at the neighborhood level.*

To help realize the full potential of this data in benefitting our city’s neighborhoods, we want this tool to be:

* User-friendly/visually appealing
* Customizable (users can select which datapoints to display for a particular neighborhood)
* Capable of displaying data over time (so that users can understand trends, put data in context)

### How it works
Users of the site will be prompted to select a neighborhood on the homepage. This will direct them to a "neighborhood page,"
where they will be able to select a number of datapoints they would like to study.

Those data would be summarized in simple boxes, like in this example from this [civic data dashboard] (https://dashboard.edmonton.ca/) from the City of Edmonton, Canada’s website.

Another aspect of Edmonton’s dashboard we plan incorporate in our app is the ability to view data over time. By clicking on one of the data boxes, a detailed explanation of the data would expand and the data would be displayed on a graph. The graph could be standalone, allowing multiple datasets to be added to it, to allow comparison.

Ideally, data with a specific location would be displayed on the page’s neighborhood map.

### Introduction for Developers
Thank you for assisting with this project! We can always use more coders to assist with what we are doing!

Our Application is built with Ruby on Rails as the backend, and React on the Frontend. In order to run theses, you need to have Ruby, Rails, and NodeJS installed on your device. There articles can assist. (Make sure you use node version 6.2.2)

NodeJS - https://nodejs.org/en/download/package-manager/
Rails - http://installrails.com/

If you are not using windows, I recommend installing the node version manager as well

NVM - https://github.com/creationix/nvm

If you are new to these concepts, these tutorials will be of great assistance.

1. [Ruby on Rails Tutorial](https://www.railstutorial.org/book) (Chapters 1-6 should be sufficient)
2. [React Tutorial](https://facebook.github.io/react/tutorial/tutorial.html) (A few examples should be suffice)

In addition, if you need assistance with git, I highly recommend going through this code school class.

[Code School GIT Course](https://www.codeschool.com/courses/try-git)

When you have cloned the application, you need to install all of the required rails dependencies to start developing.

    bundle install --without production

Once you have checkout out this application, run the following command to setup your Database

    bundle exec rake db:create db:migrate db:seed

After your database is ready, you now need to install the node modules.

    sudo npm install

From here, what's left is running the following command to compile the react code.

    sudo npm run webpack

Finally, run the following command to start the server

    rails server

When this command is kicked off, a webpack dev server should be running that continually rebuilds your React code. Essentially, if you change and of the code inside app/js, the application should refresh itself. If you don't see that occur, run the following command to manually recompile the React code.

    sudo npm run webpack

That's all you need! Now head to <http://localhost:3000> to view the application!
