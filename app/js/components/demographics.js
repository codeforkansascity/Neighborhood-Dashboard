import { default as React, PropTypes } from 'react'
import { render } from 'react-dom'
import axios from 'axios';

class Demographics extends React.Component {
  constructor(props) {
    super(props);
    this.state = {}

    var _this = this;

    axios.get('/api/neighborhood/' + this.props.params.neighborhoodId + '/census_data')
      .then(function(response) {
        _this.setState({
          ... _this.state,
          data: response.data
        })
      })
      .then(function(error) {
        console.log(error);
      });
  }

  outputCategoryRowHeader(title) {
    return (
      <tr>
        <th><strong>{title}</strong></th>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
    )
  }

  outputHousingMeanRents(data, censusDataStatistics, averageCensusStatistics) {
    var average;

    if(censusDataStatistics['2000'].aggregate_rent_spent_by_all_renter_housing_units === 0) {
      average = ''
    } else {
      average = Number((100 * censusDataStatistics['2010'].aggregate_rent_spent_by_all_renter_housing_units / censusDataStatistics['2000'].aggregate_rent_spent_by_all_renter_housing_units).toFixed(2)) + '%';
    }
    return (
      <tr>
        <th>Mean Rents</th>
        <td>{Number(censusDataStatistics['2000'].aggregate_rent_spent_by_all_renter_housing_units.toFixed(2)).toLocaleString()}</td>
        <td>{Number(censusDataStatistics['2010'].aggregate_rent_spent_by_all_renter_housing_units.toFixed(2)).toLocaleString()}</td>
        <td>
          {average}
        </td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
  )
  } 

  outputHousingCategoryRow(data, censusDataStatistics, averageCensusStatistics) {
    return (
      <tr>
        <th>{data.title}</th>
        <td>
          {Number(censusDataStatistics['2000'][data.key].toFixed(0)).toLocaleString()}
        </td>
        <td>
          {Number(censusDataStatistics['2010'][data.key].toFixed(0)).toLocaleString()}
        </td>
        <td>
          {Number(((100 * censusDataStatistics['2010'][data.key] / censusDataStatistics['2000'][data.key]) - 100).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * censusDataStatistics['2000'][data.key] / censusDataStatistics['2000'].housing_units).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * censusDataStatistics['2010'][data.key] / censusDataStatistics['2010'].housing_units).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * averageCensusStatistics['2000'][data.key] / censusDataStatistics.total_housing_units['2000']).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * averageCensusStatistics['2010'][data.key] / censusDataStatistics.total_housing_units['2010']).toFixed(2)).toLocaleString()}%
        </td>
      </tr>
    );
  }

  outputHousingCategoryRow2010Only(data, censusDataStatistics, averageCensusStatistics) {
    return (
      <tr>
        <th>{data.title}</th>
        <td>
        </td>
        <td>
          {Number(censusDataStatistics['2010'][data.key].toFixed(0)).toLocaleString()}
        </td>
        <td>
        </td>
        <td>
        </td>
        <td>
          {Number((100 * censusDataStatistics['2010'][data.key] / censusDataStatistics['2010'].housing_units).toFixed(2)).toLocaleString()}%
        </td>
        <td>
        </td>
        <td>
          {Number((100 * averageCensusStatistics['2010'][data.key] / censusDataStatistics.total_housing_units['2010']).toFixed(2)).toLocaleString()}%
        </td>
      </tr>
    );
  }

  outputPopulationCategoryRow(data, censusDataStatistics, averageCensusStatistics) {
    return (
      <tr>
        <th>{data.title}</th>
        <td>
          {Number(censusDataStatistics['2000'][data.key].toFixed(0)).toLocaleString()}
        </td>
        <td>
          {Number(censusDataStatistics['2010'][data.key].toFixed(0)).toLocaleString()}
        </td>
        <td>
          {Number(((100 * censusDataStatistics['2010'][data.key] / censusDataStatistics['2000'][data.key]) - 100).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * censusDataStatistics['2000'][data.key] / censusDataStatistics['2000'].population).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * censusDataStatistics['2010'][data.key] / censusDataStatistics['2010'].population).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * averageCensusStatistics['2000'][data.key] / censusDataStatistics.total_city_population['2000']).toFixed(2)).toLocaleString()}%
        </td>
        <td>
          {Number((100 * averageCensusStatistics['2010'][data.key] / censusDataStatistics.total_city_population['2010']).toFixed(2)).toLocaleString()}%
        </td>
      </tr>
    );
  }

  outputHousingDataHeaderRow(data, censusDataStatistics, averageCensusStatistics) {
    return (
      <tr>
          <th><strong>{data.title}</strong></th>
          <td>{Number(censusDataStatistics['2000'][data.key].toFixed(0))}</td>
          <td>{Number(censusDataStatistics['2010'][data.key].toFixed(0))}</td>
          <td>
            {Number(((100 * censusDataStatistics['2010'][data.key] / censusDataStatistics['2000'][data.key]) - 100).toFixed(2))}%
          </td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
    )
  }

  outputPopulationData() {
    var censusDataStatistics = this.state.data;
    var averageCensusStatistics = this.state.data.average_city_totals;

    var colummsCategories = [
      {title: 'Gender', dataSets: [{key: 'male', title: 'Male'}, {key: 'female', title: 'Female'}]},
      {title: 'Age', dataSets: [{key: 'school_age', title: 'School Age (5-19)'}, {key: 'elderly', title: 'Older Adults'}]},
      {
        title: 'Race', 
        dataSets: [
          {key: 'white', title: 'White'},
          {key: 'black', title: 'Black'},
          {key: 'native_american', title: 'Native American Asian/Pacific Islander'},
          {key: 'other_race', title: 'Other race'},
          {key: 'multiracial', title: 'Multiracial'},
          {key: 'hispanic', title: 'All Hispanic'}
        ]
      }
    ]

    var dataRows = []

    colummsCategories.forEach((data) => {
      dataRows.push(this.outputCategoryRowHeader(data.title));

      data.dataSets.forEach((data) => {
        dataRows.push(this.outputPopulationCategoryRow(data, censusDataStatistics, averageCensusStatistics))
      });
    });

    return (
      <tbody className="expandable-row">
        <tr className="expandable-trigger">
          <th colSpan="">
            <span className="btn btn-default glyphicon glyphicon-plus"></span>
            <strong>Population</strong>
          </th>
          <td>
            {Number(censusDataStatistics['2000'].population.toFixed(0)).toLocaleString()}
          </td>
          <td>
            {Number(censusDataStatistics['2010'].population.toFixed(0)).toLocaleString()}
          </td>
          <td>
            {Number(((100 * censusDataStatistics['2010'].population / censusDataStatistics['2000'].population) - 100).toFixed(2)).toLocaleString()}%
          </td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        {dataRows}
      </tbody>
    )
  }

  outputHousingData() {
    var censusDataStatistics = this.state.data;
    var averageCensusStatistics = this.state.data.average_city_totals;

    var colummsCategories = [
      {
        title: 'Occupancy', 
        dataSets: [
          {key: 'owner_occupied_housing_units', title: 'Owner Occupied'}, 
          {key: 'renter_occupied_housing_units', title: 'Renter Occupied'},
        ]
      },
      {
        title: 'Vacancy', 
        dataSets: [
          {key: 'vacant_housing_units', title: 'Total Vacant'}, 
          {key: 'vacant_other', title: 'Vacant: Not for sale or rent'}
        ]
      },
      {
        title: 'Housing units moved into during previous 5 years',
        type: 'data_row',
        key: 'housing_units_moved_into_during_previous_5_years'
      },
      {
        title: 'Household Size',
        dataSets: [
          {key: '1_person_households', title: '1-Person Households'},
          {key: '2_person_households', title: '2-Person Households'},
          {key: '3_person_households', title: '3-Person Households'},
          {key: '4_person_households', title: '4-Person Households'},
          {key: '5_person_households', title: '5-Person Households'},
          {key: '6_person_households', title: '6-Person Households'},
          {key: '7_or_more_person_households', title: '7 Or More Person Households'}

        ]
      },
      {
        title: 'Household Type',
        dataSets: [
          {key: 'married_couple_households_with_own_children_present', title: 'Married Couple Households with Own Children'},
          {key: 'married_couple_households_without_own_children_present', title: 'Married Couple without Own Children'},
          {key: 'female_householder_households__no_husband_present__with_own_children_present', title: 'Female Householders Households, no Husband Present, with Own Children'},
          {key: 'female_householder_households__no_husband_present__without_own_children_present', title: 'Female Householders Households, no Husband Present, without Own Children'},
          {key: 'non_family_households', title: 'Non Family Households'},
          {key: 'overcrowded_housing_units', title: 'Overcrowding Housing Units'}
        ]
      },
      {
        title: 'Housing Costs',
        dataSets: [
          {key: 'aggregate_rent_spent_by_all_renter_housing_units', title: 'Mean Rents'}
        ]
      },
      {
        title: 'Housing Year Built',
        dataSets: [
          {key: 'housing_units_built_before_1940', title: 'Housing Units Built Before 1940'},
          {key: 'housing_units_built_1940_1949', title: 'Housing Units Built 1940-1949'},
          {key: 'housing_units_built_1950_1959', title: 'Housing Units Built 1950-1959'},
          {key: 'housing_units_built_1960_1969', title: 'Housing Units Built 1960-1969'},
          {key: 'housing_units_built_1970_1979', title: 'Housing Units Built 1970-1979'},
          {key: 'housing_units_built_1980_1989', title: 'Housing Units Built 1980-1989'},
          {key: 'housing_units_built_1990_1999', title: 'Housing Units Built 1990-1999'},
          {key: 'housing_units_built_2000_2009', title: 'Housing Units Built 2000-2009'},
        ]
      }
    ]

    var dataRows = []

    colummsCategories.forEach((data) => {
      if(data.type == 'data_row') {
        dataRows.push(this.outputHousingDataHeaderRow(data, censusDataStatistics, averageCensusStatistics))
      } else {
        dataRows.push(this.outputCategoryRowHeader(data.title));

        data.dataSets.forEach((data) => {
          if (data.key == 'housing_units_built_2000_2009') {
            dataRows.push(this.outputHousingCategoryRow2010Only(data, censusDataStatistics, averageCensusStatistics));
          } else if (data.key == 'aggregate_rent_spent_by_all_renter_housing_units'){
            dataRows.push(this.outputHousingMeanRents(data, censusDataStatistics, averageCensusStatistics));
          }
          else{
            dataRows.push(this.outputHousingCategoryRow(data, censusDataStatistics, averageCensusStatistics));
          }
        });
      }
    });

    return (
      <tbody className="expandable-row">
        <tr className="expandable-trigger">
          <th colSpan="">
            <span className="btn btn-default glyphicon glyphicon-plus"></span>
            <strong>Housing</strong>
          </th>
          <td>
            {Number(censusDataStatistics['2000'].housing_units.toFixed(0)).toLocaleString()}
          </td>
          <td>
            {Number(censusDataStatistics['2010'].housing_units.toFixed(0)).toLocaleString()}
          </td>
          <td>
            {Number(((100 * censusDataStatistics['2010'].housing_units / censusDataStatistics['2000'].housing_units) - 100).toFixed(2)) }%
          </td> 
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        {dataRows}
      </tbody>
    )
  }

  render() {
    if (this.state.data) {
      return(
        <div className="statistics-panel">
          <table className="statistics-table">
            <thead>
              <tr className="title-row">
                <th>
                </th>
                <th colSpan="2">
                  Total
                </th>
                <th>
                  Change
                </th>
                <th colSpan="2">
                  % of Neighborhood
                </th>
                <th colSpan="2">
                  City Average
                </th>
              </tr>
              <tr className="sub-title-row">
                <th>
                </th>
                <th>
                  2000
                </th>
                <th>
                  2008-2012 ACS
                </th>
                <th></th>
                <th>
                  2000
                </th>
                <th>
                  2008-2012 ACS
                </th>
                <th>
                  2000
                </th>
                <th>
                  2008-2012 ACS
                </th>
              </tr>
            </thead>
            {this.outputPopulationData()}
            {this.outputHousingData()}
          </table>
        </div>
      )
    } else {
      return (<div/>)
    }
  }
}

export default Demographics;
