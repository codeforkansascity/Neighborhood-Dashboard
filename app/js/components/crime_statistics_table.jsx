import React from 'react';
import { render } from 'react-dom';

class CrimeStatisticsTable extends React.Component {

  formatData(data) {
    const formattedData = {
      PERSON: {
        title: 'Person',
      },
      PROPERTY: {
        title: 'Property',
      },
      SOCIETY: {
        title: 'Society',
      },
    };

    formattedData.PERSON.data =
    [
      {
        title: 'Assault',
        value: data.PERSON.ASSAULT_AGGRAVATED
        + data.PERSON.ASSAULT_SIMPLE + data.PERSON.ASSAULT_INTIMIDATION
      },
      {
        title: 'Homicide',
        value: data.PERSON.HOMICIDE_NONNEGLIGENT_MANSLAUGHTER
        + data.PERSON.HOMICIDE_NEGLIGENT_MANSLAUGHETER
      },
      {
        title: 'Sex Offenses, Forcible',
        value: data.PERSON.SEX_OFFENSE_RAPE +
        data.PERSON.SEX_OFFENSE_SODOMY +
        data.PERSON.SEX_OFFENSE_ASSAULT_WITH_OBJECT +
        data.PERSON.SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE
      },
      {
        title: 'Sex Offenses, Non-Forcible',
        value: data.PERSON.SEX_OFFENSE_NONFORCIBLE_INCEST +
        data.PERSON.SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE,
      },
    ];

    formattedData.PROPERTY.data =
    [
      {
        title: 'Arson',
        value: data.PROPERTY.ARSON,
      },
      {
        title: 'Bribery',
        value: data.PROPERTY.BRIBERY,
      },
      {
        title: 'Burglary',
        value: data.PROPERTY.BURGLARY,
      },
      {
        title: 'Forgery',
        value: data.PROPERTY.FORGERY,
      },
      {
        title: 'Vandalism',
        value: data.PROPERTY.VANDALISM,
      },
      {
        title: 'Embezzlement',
        value: data.PROPERTY.EMBEZZLEMENT,
      },
      {
        title: 'Extortion',
        value: data.PROPERTY.EXTORTING,
      },
      {
        title: 'Fraud, Swindle',
        value: data.PROPERTY.FRAUD_SWINDLE,
      },
      {
        title: 'Fraud, Credit Care',
        value: data.PROPERTY.FRAUD_CREDIT_CARD,
      },
      {
        title: 'Fraud, Impersonation',
        value: data.PROPERTY.FRAUD_IMPERSONATION,
      },
      {
        title: 'Fraud, Impersonation',
        value: data.PROPERTY.FRAUD_WELFARE,
      },
      {
        title: 'Fraud, Welfare',
        value: data.PROPERTY.ARSON,
      },
      {
        title: 'Fraud, Wire',
        value: data.PROPERTY.ARSON,
      },
    ];

    formattedData.SOCIETY.data = [
      {
        title: 'Fraud, Wire',
        value: data.PROPERTY.ARSON,
      },
    ];

    formattedData.PERSON.count = this.calculateTotals(formattedData.PERSON.data);
    formattedData.PROPERTY.count = this.calculateTotals(formattedData.PROPERTY.data);

    return formattedData;
  }

  calculateTotals(data) {
    return data.reduce((sum, data) => (sum + data.value), 0);
  }

  expandableRow(dataGroup) {
    return (
      <tbody className="expandable-row">
      <tr className="expandable-trigger">
        <th>
          <span className="btn btn-default glyphicon glyphicon-plus"></span>
          <span>
              <span className="text-muted">Crimes Against</span>
              <br />
              <strong>{dataGroup.title}</strong>
            </span>
        </th>
        <td>
          {dataGroup.count}
        </td>
      </tr>
      {
        dataGroup.data.map(function (data) {
          return (
            <tr>
              <th>{data.title}</th>
              <td>{data.value}</td>
            </tr>
          );
        })
      }
      </tbody>
    );
  }

  render() {
    const data = this.formatData(this.props.data);

    if (data) {
      return (
        <table className="statistics-table">
          <thead>
          <tr className="title-row">
            <th>
            </th>
            <th colSpan="4">
              Annual
            </th>
          </tr>
          <tr className="sub-title-row">
            <th>
            </th>
            <th colSpan="4">
              Total Incidents from Previous Year
            </th>
          </tr>
          </thead>
          {this.expandableRow(data.PERSON)}
          {this.expandableRow(data.PROPERTY)}
        </table>
      );
    } else {
      return <div />;
    }
  }
}

export default CrimeStatisticsTable;
