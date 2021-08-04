import React, {useEffect} from 'react';

import { makeStyles } from '@material-ui/core/styles';
import InputLabel from '@material-ui/core/InputLabel';
import Input from '@material-ui/core/Input';
import MenuItem from '@material-ui/core/MenuItem';
import ListSubheader from '@material-ui/core/ListSubheader';
import FormControl from '@material-ui/core/FormControl';
import Select from '@material-ui/core/Select';
import { withComponentFeatures } from 'universal-dashboard';
import {FormContext} from './form';

const useStyles = makeStyles(theme => ({
  formControl: {
    margin: theme.spacing(1),
    minWidth: 120,
  },
}));

const UDSelectWithContext = (props) => {
    return (
        <FormContext.Consumer>
            {
                ({onFieldChange}) => <UDSelect {...props} onFieldChange={onFieldChange} />
            }
        </FormContext.Consumer>

    )
}

const UDSelect = (props) => {
    const classes = useStyles();
    const groups = props.options.filter(m => m.type === 'mu-select-group');

    const onChange = (event) => {
        var value = event.target.value;
        if (Array.isArray(value))
        {
            value = value.filter(x => x != null && x != undefined);
            var temp = []
            value.forEach(x => {
                const group = groups.find(v => v.name === x);
                if (group)
                {
                    group.options.forEach(opt => temp.push(opt.value));
                }
                else 
                {
                    temp.push(x);
                }
            });

            value = temp;
        }

        props.onFieldChange({id: props.id, value : value})
        props.setState({ value : value})

        if (props.onChange) {
            props.onChange(value);
        }
    }

    let defaultValue = null;
    let options = [];
    if (groups.length > 0)
    {
        options = groups.map(x => {

            const groupStyle = {
                color: 'rgba(0, 0, 0, 0.54)',
                fontSize: '0.875rem',
                boxSizing: 'border-box',
                listStyle: 'none',
                fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
                fontWeight: 500
            }

            return [
                <MenuItem style={groupStyle} value={x.name}>{x.name}</MenuItem>,
                x.options.map(m => <MenuItem value={m.value}>{m.name}</MenuItem>)
            ]
        })
    }
    else if (props.options && props.options.map && props.options.length > 0)
    {
        defaultValue = props.defaultValue || props.options[0].value;
        options = props.options.map(x => <MenuItem value={x.value}>{x.name}</MenuItem>)
    }

    if (props.multiple && !Array.isArray(defaultValue)) {
        if (defaultValue)
        {
            defaultValue = [defaultValue];
        }
        else 
        {
            defaultValue = []
        }
    }

    if (!props.value) {
        props.setState({value: defaultValue})
    }

    useEffect(() => {
        props.onFieldChange({id: props.id, value: defaultValue});
        return () => {}
    }, true)

    return (
        <FormControl className={classes.formControl} key={props.id} >
            <InputLabel htmlFor={props.id}>{props.label}</InputLabel>
            <Select 
                defaultValue={defaultValue} 
                input={<Input id={props.id} />} 
                value={props.value} 
                onChange={event => onChange(event)}
                multiple={props.multiple}
                disabled={props.disabled}
            >
                {options}
            </Select>
        </FormControl>
    )
}

export default withComponentFeatures(UDSelectWithContext);