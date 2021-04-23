import React from "react"
import PropTypes from "prop-types"
import ExampleListItem from "./ExampleListItem"

class ExampleList extends React.Component {
  render () {
    return (
      <div className="example-list">
        <header>
          <h2>Example List</h2>
        </header>
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            {this.props.items.map(item => (
              <ExampleListItem key={item.id} name={item.name} description={item.description} />
            ))}
          </tbody>
        </table>

        <a href={this.props.prev}>Prev Page</a> | <a href={this.props.next}>Next Page</a>
      </div>
    );
  }
}

ExampleList.propTypes = {
  items: PropTypes.array,
  prev: PropTypes.string,
  next: PropTypes.string
};
export default ExampleList
