import React, { useEffect, useState } from 'react';
import TextField from '@material-ui/core/TextField';
import Autocomplete from '@material-ui/lab/Autocomplete';
import CircularProgress from '@material-ui/core/CircularProgress';
import {FormContext} from './form';
import { withComponentFeatures } from 'universal-dashboard'
import throttle from 'lodash/throttle';


const UDAutocompleteWithContext = (props) => {
    return (
        <FormContext.Consumer>
            {
                ({onFieldChange}) => <UDAutocomplete {...props} onFieldChange={onFieldChange} />
            }
        </FormContext.Consumer>
    )
}

function UDAutocomplete(props) {

    const onChange = (event, value) => {
        props.onFieldChange({id: props.id, value : value})
        props.setState({ value : value})

        if (props.onChange) {
          props.onChange(value);
      }
    }

    var value = props.value;
    if (!Array.isArray(value) && props.multiple)
    {
       value = (value == null || value === '') ? [] : [value];
    }

    useEffect(() => {
      props.onFieldChange({id: props.id, value : props.value})
      return () => {}
    }, true)

    if (!props.onLoadOptions) {
        return <Autocomplete
            id={props.id}
            onChange={onChange}
            options={props.options}
            getOptionLabel={(option) => option}
            value={value}
            fullWidth={props.fullWidth}
            multiple={props.multiple}
            renderInput={(params) => <TextField {...params} label={props.label} variant={props.variant} fullWidth/>}
        />
    }

    const [inputValue, setInputValue] = React.useState('');
    const [options, setOptions] = useState([]);
    
    const handleChange = (event) => {
        setInputValue(event.target.value);
    };

    const fetch = React.useMemo(
        () =>
          throttle((request, callback) => {
              props.onLoadOptions(request).then(callback);
          }, 200),
        [],
      );
  
    React.useEffect(() => {
        let active = true;
    
        if (inputValue === '') {
          setOptions([]);
          return undefined;
        }
    
        fetch(inputValue, (results) => {
          if (active) {

              let json = JSON.parse(results);

              if (!Array.isArray(json)) {
                json = [json]
              }
              setOptions(json || []);
          }
        });
    
        return () => {
          active = false;
        };
      }, [inputValue, fetch]);

    return (
      <Autocomplete
        id={props.id}
        //getOptionLabel={(option) => (typeof option === 'string' ? option : option.description)}
        filterOptions={(x) => x}
        options={options}
        autoComplete
        includeInputInList
        onChange={onChange}
        value={value}
        multiple={props.multiple}
        fullWidth={props.fullWidth}
        renderInput={(params) => (
            <TextField
              {...params}
              label={props.label}
              variant={props.variant}
              fullWidth
              onChange={handleChange}
            />
          )}
      />
    );
  }

  export default withComponentFeatures(UDAutocompleteWithContext);