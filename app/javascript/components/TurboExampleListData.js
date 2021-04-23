import React from "react"
import PropTypes from "prop-types"
import eventBus from "./EventBus"

class TurboExampleListData extends React.Component {
  componentDidMount() {
    eventBus.on("pageRequested", (data) => eventBus.dispatch("pageLoaded", this.props));
    eventBus.dispatch("pageLoaded", this.props);
  }

  componentWillUnmount() {
    eventBus.remove("pageRequested");
  }

  render() {
    return null;
  }
}

TurboExampleListData.propTypes = {
  items: PropTypes.array,
  prev: PropTypes.string,
  next: PropTypes.string
};

export default TurboExampleListData
