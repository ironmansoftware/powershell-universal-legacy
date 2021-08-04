import React, {useState, useReducer, useEffect} from 'react';
import Button from '@material-ui/core/Button';
import Grid from '@material-ui/core/Grid';
import { withComponentFeatures } from 'universal-dashboard';
import { makeStyles } from '@material-ui/core/styles';
import UDIcon from './icon';

const defaultContext = {
    fields: {},
    onFieldChange: (field) => {},
    submit: () => {}
}

export const FormContext = React.createContext(defaultContext);

const useStyles = makeStyles(theme => ({
    formControlPadding: {
      padding: theme.spacing(1),
    },
  }));


const reducer = (state, action) => {
    switch (action.type) {
        case 'changeField':
            var newState = {...state};
            newState[action.id] = action.value;
            return newState;
        default:
          throw new Error();
      }
}

const UDForm = (props) => {

    const classes = useStyles();

    const [fields, setFields] = useReducer(reducer, {});
    const [valid, setValid] = useState(props.onValidate == null);
    const [canSubmit, setCanSubmit] = useState(props.onValidate == null);
    const [validationError, setValidationError] = useState("");
    const [content, setContent] = useState(props.children);
    const [hideSubmit, setHideSubmit] = useState(false);
    const [submitting, setSubmitting] = useState(false);

    const validate = () => {
        props.onValidate(fields).then(x => {

            var json = JSON.parse(x);

            if (Array.isArray(json))
            {
                json = json[0]
            }

            setValid(json.valid);
            setCanSubmit(json.valid);
            setValidationError(json.validationError);
        });
    }

    const incomingEvent = (type, event) => {
        if (type === "testForm" && props.onValidate) {
            validate();
        }
    }

    useEffect(() => {
        const token = props.subscribeToIncomingEvents(props.id, incomingEvent)
        return () => {
            props.unsubscribeFromIncomingEvents(token)
        }
    });

    var components = [];
    
    if (Object.keys(content).length > 0)
    {
        components = props.render(content);
    }
    
    if (!components.map)
    {
        components = [components];
    }

    const onSubmit = () => {
        setSubmitting(true);
        props.onSubmit(fields).then(x => {

            try
            {
                x = JSON.parse(x);
            }
            catch {}

            if (x && Object.keys(x).length > 0) {
                setContent(x);
                setHideSubmit(true);
            }
            setSubmitting(false);
        })
    }

    if (props.onValidate)
    {
        useEffect(() => {
            validate();
        }, [fields]);
    }
    
    const contextState = {
        onFieldChange: (field) => {
            setFields({
                type: 'changeField',
                ...field
            });
        },
        submit: () => { if (canSubmit && !submitting && !hideSubmit) { onSubmit() } }
    }

    if (submitting && props.loadingComponent) {
        return props.render(props.loadingComponent);
    }

    var submitButton = null;
    if (!hideSubmit) {
        submitButton = (
            <Grid item xs={6}>
                {valid ? <React.Fragment></React.Fragment> : <div style={{color: 'red'}} id={props.id + "-validationError"}><UDIcon icon="Exclamation" /> {validationError}</div>}
                <Button variant={props.buttonVariant} onClick={onSubmit} disabled={!canSubmit} className={classes.formControlPadding}>{props.submitText}</Button>
            </Grid>
        )
    }

    var cancelButton = null;
    if (props.onCancel) {
        cancelButton = <Grid item xs={6}>
            <Button variant={props.buttonVariant} onClick={() => props.onCancel()} className={classes.formControlPadding}>{props.cancelText}</Button>
        </Grid>
    }

    if (submitting) {
        submitButton = (
            <Grid item xs={12}>
                <Button variant={props.buttonVariant} disabled={true} className={classes.formControlPadding}><UDIcon icon="Spinner" spin/> {props.submitText}</Button>
            </Grid>
        )
    }

    return (
        <div id={props.id}>
            <FormContext.Provider value={contextState}>
                <Grid container>
                    {components.map(x => <Grid item xs={12} className={classes.formControlPadding}>{x}</Grid>)}
                    {submitButton}
                    {cancelButton}
                </Grid>
            </FormContext.Provider>
        </div>
    )
}

export default withComponentFeatures(UDForm);