import React from 'react';
import {Select} from 'react-materialize';

export default class UDSelect extends React.Component {

    constructor() {
        super();

        this.state = {
            value: ''
        }
    }

    componentWillMount() {
        this.pubSubToken = UniversalDashboard.subscribe(this.props.id, this.onIncomingEvent.bind(this));
    }

    onIncomingEvent(eventName, event) {
        if (event.type === "requestState") {

            var data = {
                attributes: {
                    value: this.state.value
                }
            }

            UniversalDashboard.post(`/api/internal/component/element/sessionState/${event.requestId}`, data);
        }
    }

    onChange(e) {
        var val = new Array();

        if (e.target.selectedOptions) {
            for(var item in  e.target.selectedOptions) {
                if (isNaN(item)) continue;
                var value = e.target.selectedOptions[item].value;
                val.push(value);
            }
        }
        else {
            val.push(e.target.value);
        }

        if (val.length === 1) {
            val = val[0]
        }
        else {
            val = JSON.stringify(val);
        }

        this.setState({
            value: val
        })

        if (this.props.onChange == null) {
            return
        }

        UniversalDashboard.publish('element-event', {
            type: "clientEvent",
            eventId: this.props.onChange,
            eventName: 'onChange',
            eventData: val
        });
    }

    render() {

        const options = this.props.options.map(
            group => {
                return group.type === 'ud-select-group' ? 
                    <optgroup label={group.name}>
                    {
                        group.options.map(goption => 
                        {
                            return <option {...goption} value={goption.value} disabled={goption.disabled}>
                                {goption.name}
                            </option> 
                        }
                        )
                    }
                </optgroup> : 
                <option {...group}  value={group.value} disabled={group.disabled}>
                    {group.name}
                </option>
            }
        )
       var selectedOption = this.props.options.map(option => {
            option.type === 'ud-select-group' ? option.options.find(x => x.selected) : this.props.options.find(x => x.selected) 
        })

        return <Select 
            multiple={this.props.multiple} 
            id={this.props.id} 
            label={this.props.label}
            browserDefault={this.props.browserDefault}
            selected={selectedOption && selectedOption.value}
            onChange={this.onChange.bind(this)}
            >
            {options}
        </Select>
    }
}
