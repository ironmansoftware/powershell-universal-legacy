import React from 'react';
import UdDashboard from './ud-dashboard.jsx'
import {
    BrowserRouter as Router,
    Route,
    Switch
} from 'react-router-dom'
import Spinner from 'react-spinkit';
import ErrorCard from './../Components/framework/error-card'
import NotAuthorized from '../Components/framework/not-authorized.jsx';
import NotRunning from '../Components/framework/not-running.jsx';

export default class App extends React.Component {

    constructor() {
        super();

        this.state = {
            loading: true,
            loadingMessage: 'Loading framework...',
            error: null,
            errorInfo: null
        }
    }

    loadJavascript(url, onLoad) {
        var jsElm = document.createElement("script");
        jsElm.onload = onLoad;
        jsElm.type = "application/javascript";
        jsElm.src = url;
        document.body.appendChild(jsElm);
    }

    componentWillMount() {
        this.setState({
            loading: false
        })
    }

    componentDidCatch(error, errorInfo) {
        this.setState({
            error,
            errorInfo
        })
    }

    render () {

        if (this.state.error) {
            const errorRecords = [
                {
                    message: this.state.error && this.state.error.toString(),
                    location: this.state.errorInfo.componentStack
                }
            ]
            return <ErrorCard errorRecords={errorRecords} />
        }

        if (this.state.loading) {
            return <div style={{backgroundColor: '#FFFFFF'}} className="v-wrap">
                        <article className="v-box">
                            <Spinner name="folding-cube" style={{width: '150px', height: '150px', color: '#0689B7'}}/>
                        </article>
                    </div>
        }

        var pluginRoutes = UniversalDashboard.provideRoutes();

        return (<Router basename={window.baseUrl}>
                <div className="ud-dashboard">
                    <Switch>
                        {pluginRoutes}
                        <Route path="/not-authorized" component={NotAuthorized} />
                        <Route path="/not-running" component={NotRunning} />
                        <Route path="/" component={UdDashboard} />
                    </Switch>
                </div>
            </Router> )
  }
}
