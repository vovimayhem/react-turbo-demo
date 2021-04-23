import React from "react"
import PropTypes from "prop-types"
import eventBus from "./EventBus"
import ExampleList from "./ExampleList"

class TurboExampleList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      items: [],
      prev: null,
      next: null
    };
  }

  componentDidMount() {
    console.log("TurboExampleList.componentDidMount...")
    eventBus.on("pageLoaded", (data) => this.setState(data));
    eventBus.dispatch("pageRequested", {});
  }

  componentWillUnmount() {
    console.log("TurboExampleList.componentWillUnmount...")
    eventBus.remove("pageLoaded");
  }

  render () {
    return (
      <ExampleList items={this.state.items} prev={this.state.prev} next={this.state.next} />
    );
  }
}

export default TurboExampleList
