import React, { useEffect, useState } from "react";
import { withComponentFeatures } from "universal-dashboard";
import TextField from "@material-ui/core/TextField";
import { FormContext } from "./form";
import UDIcon from "./icon";
import InputAdornment from "@material-ui/core/InputAdornment";
import MaskedInput from "react-text-mask";
import { FormControl, FormHelperText, Input, InputLabel } from "@material-ui/core";

const UDTextFieldWithContext = (props) => {
  return (
    <FormContext.Consumer>
      {({ onFieldChange, submit }) => (
        <UDTextField {...props} onFieldChange={onFieldChange} submit={submit} />
      )}
    </FormContext.Consumer>
  );
};

function TextMaskCustom(props) {
  const { inputRef, ...other } = props;
  console.log("mask", props);
  const mask = Array.isArray(props.mask)
    ? props.mask.map((x) =>
        x.startsWith("/") && x.endsWith("/")
          ? new RegExp(x.substr(1, x.length - 2))
          : x
      )
    : [];
  return (
    <MaskedInput
      {...other}
      ref={(ref) => {
        inputRef(ref ? ref.inputElement : null);
      }}
      autoFocus
      mask={mask}
      placeholderChar={"\u2000"}
      showMask
    />
  );
}

const UDTextField = (props) => {
    const onChange = (e) => {
        props.setState({value: e.target.value})
    }

    useEffect(() => {
        props.onFieldChange({id: props.id, value: props.value})
    }, [props.value])

  return props?.mask ? (
    <FormControl>
      <InputLabel htmlFor={props?.id}>{props?.label}</InputLabel>
      <Input
        {...props}
        value={props?.value}
        onChange={onChange}
        startAdornment={
          props?.icon ? (
            <InputAdornment position="start">
              <UDIcon {...props.icon} />
            </InputAdornment>
          ) : null
        }
        name="textmask"
        id={props?.id}
        inputComponent={(p) => <TextMaskCustom {...p} mask={props?.mask} />}
      />
      {props?.helperText && (
        <FormHelperText id={props?.id}>{props?.helperText}</FormHelperText>
      )}
    </FormControl>
  ) : (
    <TextField
      {...props}
      type={props.textType}
      onChange={onChange}
      onKeyUp={(e) => e.key === "Enter" && props.submit()}
      InputLabelProps={{
        shrink: props?.value || props?.label,
      }}
      InputProps={{
        startAdornment: props?.icon ? (
          <InputAdornment position="start">
            <UDIcon {...props.icon} />
          </InputAdornment>
        ) : null,
      }}
    />
  );
};

export default withComponentFeatures(UDTextFieldWithContext);
