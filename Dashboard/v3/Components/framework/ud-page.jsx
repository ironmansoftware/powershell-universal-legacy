import React, { useState, useEffect } from 'react';
import ErrorCard from './error-card.jsx';
import ReactInterval from 'react-interval';
import {withComponentFeatures} from 'universal-dashboard';
import Skeleton from '@material-ui/lab/Skeleton';
import { makeStyles } from '@material-ui/core/styles';
import UdNavBar from './ud-navbar';
import CssBaseline from '@material-ui/core/CssBaseline';
import Toolbar from '@material-ui/core/Toolbar';

const useStyles = makeStyles((theme) => ({
    root: {
        backgroundColor: theme.palette.background.default,
        height: '100vh',
        display: props => props.navLayout === "permanent" ? 'flex' : null
      },
    main: {
        flexGrow: 1,
        padding: theme.spacing(3),
    }
  }));

const UDPage = (props) => {
    const classes = useStyles(props);

    document.title = props.name;

    const [components, setComponents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [hasError, setHasError] = useState(false);
    const [errorMessage, setErrorMessage] = useState('');
    const [navigation, setNavigation] = useState(props.navigation);

    const loadData = () => {
        if (!props.match) {
            return;
        }

        var queryParams = {};

        for (var k in props.match.params) {
            if (props.match.params.hasOwnProperty(k)) {
                queryParams[k] = props.match.params[k];
            }
        }

        var esc = encodeURIComponent;
        var query = Object.keys(queryParams)
            .map(k => esc(k) + '=' + esc(queryParams[k]))
            .join('&');
    
        UniversalDashboard.get(`/api/internal/component/element/${props.id}?${query}`, json => {
            if (json.error) {
                setErrorMessage(json.error.message);
                setHasError(true);
            }
            else  {
                setComponents(json);
                setHasError(false);
            }

            if (props.loadNavigation) {
                props.loadNavigation().then(json => { 
                    const nav = JSON.parse(json);
                    setNavigation(nav);
                    setLoading(false);
                });
            }
            else {
                setLoading(false);
            }
        });
    }

    useEffect(() => {
        loadData();
        return () => {}
    }, true)
    
    if (hasError) {
        return <ErrorCard message={errorMessage} id={props.id} title={"An error occurred on this page"}/>
    }

    if (loading)
    {
        if (props.onLoading) {
            return props.render(props.onLoading);
        }
        
        return <div className={classes.root}>
                <Skeleton />
                <Skeleton />
                <Skeleton />
            </div>
    }

    var childComponents = props.render(components);

    if (props.blank)
    {
        return <div className={classes.root}>
            {childComponents}
            <ReactInterval timeout={props.refreshInterval * 1000} enabled={props.autoRefresh} callback={loadData}/>
        </div>
    }
    else 
    {
        return <div className={classes.root}>
            <CssBaseline />
            <UdNavBar 
                pages={props.pages} 
                title={props.name} 
                history={props.history} 
                id="defaultNavbar" fixed={props.navLayout === "permanent"} navigation={navigation} logo={props.logo}
                disableThemeToggle={props.disableThemeToggle} 
                user={props.user}
                windowsAuth={props.windowsAuth} />
            <main className={classes.main}>
                {props.navLayout === "permanent" ? <Toolbar /> : <React.Fragment />}
                {childComponents}
            </main>
            
            <ReactInterval timeout={props.refreshInterval * 1000} enabled={props.autoRefresh} callback={loadData}/>
        </div>
    }
}

export default withComponentFeatures(UDPage);