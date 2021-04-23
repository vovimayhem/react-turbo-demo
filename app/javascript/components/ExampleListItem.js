import React from "react"
import PropTypes from "prop-types"


class ExampleListItem extends React.Component {
  render () {
    return (
      <tr>
        <td>{this.props.name}</td>
        <td>{this.props.description}</td>
      </tr>
    );
  }
}

ExampleListItem.propTypes = {
  name: PropTypes.string,
  description: PropTypes.string
};
export default ExampleListItem
