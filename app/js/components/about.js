import React from 'react'
import { render } from 'react-dom'

import PrimaryNavigation from './primary_navigation'

const About = () => {

  return (
    <div>
      <PrimaryNavigation />
      <div className="container">
        <h1>Welcome to the KCNeighborhoodStat app project!</h1>
        <p>
          We're working to help neighborhoods help themselves by giving them easy access to useful civic open data. 
          We're ultimately hoping to develop an app that - by providing easier access to civic open data
           - lets neighborhood organization and neighbors:
        </p>
        <ul>
          <li>
            <b>Better understand their neighborhood through data</b>What is my neighborhood- what are its boundaries? How many people live there? How much crime happens here?
          </li>
          <li>
            <b>More easily track development and others projects in their neighborhoods</b> Is a new business opening down the street? Is a building being torn down?
          </li>
          <li>
            <b>Make better decisions as a community</b> Do we have a lot of senior citizens that need help with minor home repair?
          </li>
          <li>
            <b>Become more effective advocates for their community</b> We need more police patrols and codes inspections- here's the data
          </li>
        </ul>
        <h2>Civic data: the opportunity</h2>
        <p>
          These days, we're seeing a greater availability of civic open data in cities across the country- Kansas City included! We believe this trend towards more open data is especially good news for the neighborhoods that make up the fabric of the city. Rich,up-to-date information about crime, development, and demographics is what neighborhoods need to make better decisions and to advocate for themselves more effectively with government agencies and other organizations.
        </p>
        <h2>Civic data: the problem</h2>
        <p>
          Unfortunately, even though the data are out there, its potential power to help neighborhoods isn’t yet realized. Accessing civic data might mean hours of wading through spreadsheets, then trying to interpret confusing terminology, or having to go through a website that is not easy to use for the average resident or neighborhood leader. Meanwhile, civic data is usually not presented at the neighborhood-level geography. Right now, for instance, it’s not possible to see the population of a neighborhood or the number of crimes that have occurred there recently.
        </p>
      </div>
    </div>
  )
}

export default About;
