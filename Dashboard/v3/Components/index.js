import React, { useState, Suspense } from 'react';

import Chip from "./chips";
import Icon from "./icon";
import Paper from "./paper";
import IconButton from "./icon-button";
import { UDList, UDListItem } from "./list";
import UDButton from "./button";
import UDMuCard from "./card";
import UDCardMedia from "./card-media";
import UDCardToolBar from "./card-toolbar";
import UDCardHeader from "./card-header";
import UDCardBody from "./card-body";
import UDCardExpand from "./card-expand";
import UDCardFooter from "./card-footer";
import Typography from "./typography";
import UDLink from "./link";
import UDAvatar from "./avatar";
import UDCheckBox from "./checkbox";
import Progress from './progress';
import ExpansionPanelGroup from './expansion-panel';
import FloatingActionButton from './floating-action-button';
import Tabs from './tabs';
import Grid from './grid';
import Transition from './transition';
// import Table from './table';
// import Table from './table/table';
// import Table from './table/ReactTable/table';
import Table from './table/v2/table';
import Select from './select';
import Textbox from './textbox';
import UDSwitch from './switch';
import UDTreeView from './treeview';
import UDDynamic from './dynamic';
import UDForm from './form';
import UDDatePicker from './datepicker';
import UDTimePicker from './timepicker';
import UDNavbar from './framework/ud-navbar';
import UDFooter from './framework/ud-footer';
import UDAppBar from './appbar';
import UDDrawer from './drawer';
import {UDRadioGroupWithContext, UDRadio } from './radio';
import NotFound from './framework/not-found';
import UDContainer from './container';
import UDAutocomplete from './autocomplete';
import UDErrorCard from './framework/error-card';
import {UDStep, UDStepper} from './stepper';
import UDSlider from './slider'
import UDUpload from './upload'
import Button from '@material-ui/core/Button';
import DateTime from './datetime';
import UDAlert from './alert';
import UDSkeleton from './skeleton';
import UDBackdrop from './backdrop';
import UDHidden from './hidden';

import {
    Route,
    Redirect,
    Switch
} from 'react-router-dom'

UniversalDashboard.register("mu-chip", Chip);
UniversalDashboard.register("mu-icon", Icon);
UniversalDashboard.register("mu-paper", Paper);
UniversalDashboard.register("mu-icon-button", IconButton);
UniversalDashboard.register("mu-list", UDList);
UniversalDashboard.register("mu-list-item", UDListItem);
UniversalDashboard.register("mu-button", UDButton);
UniversalDashboard.register("mu-card", UDMuCard);
UniversalDashboard.register("mu-card-media", UDCardMedia);
UniversalDashboard.register("mu-card-toolbar", UDCardToolBar);
UniversalDashboard.register("mu-card-header", UDCardHeader);
UniversalDashboard.register("mu-card-body", UDCardBody);
UniversalDashboard.register("mu-card-expand", UDCardExpand);
UniversalDashboard.register("mu-card-footer", UDCardFooter);
UniversalDashboard.register("mu-typography", Typography);
UniversalDashboard.register("mu-link", UDLink);
UniversalDashboard.register("mu-avatar", UDAvatar);
UniversalDashboard.register("mu-checkbox", UDCheckBox);
UniversalDashboard.register("mu-progress", Progress);
UniversalDashboard.register('mu-expansion-panel-group', ExpansionPanelGroup);
UniversalDashboard.register('mu-fab', FloatingActionButton);
UniversalDashboard.register('mu-tabs', Tabs);
UniversalDashboard.register('mu-grid', Grid);
UniversalDashboard.register('mu-table', Table);
UniversalDashboard.register('mu-select', Select);
UniversalDashboard.register('mu-textbox', Textbox);
UniversalDashboard.register('mu-switch', UDSwitch);
UniversalDashboard.register('mu-treeview', UDTreeView);
UniversalDashboard.register('dynamic', UDDynamic);
UniversalDashboard.register('mu-form', UDForm);
UniversalDashboard.register('mu-datepicker', UDDatePicker);
UniversalDashboard.register('mu-timepicker', UDTimePicker);
UniversalDashboard.register('ud-navbar', UDNavbar);
UniversalDashboard.register('ud-footer', UDFooter);
UniversalDashboard.register('mu-appbar', UDAppBar);
UniversalDashboard.register('mu-drawer', UDDrawer);
UniversalDashboard.register('mu-radio', UDRadio);
UniversalDashboard.register('mu-radiogroup', UDRadioGroupWithContext);
UniversalDashboard.register('mu-container', UDContainer);
UniversalDashboard.register("mu-autocomplete", UDAutocomplete);
UniversalDashboard.register("error", UDErrorCard);
UniversalDashboard.register("mu-stepper-step", UDStep);
UniversalDashboard.register("mu-stepper", UDStepper);
UniversalDashboard.register("mu-slider", UDSlider);
UniversalDashboard.register("mu-upload", UDUpload);
UniversalDashboard.register("mu-datetime", DateTime);
UniversalDashboard.register("mu-transition", Transition);
UniversalDashboard.register("mu-alert", UDAlert);
UniversalDashboard.register("mu-skeleton", UDSkeleton);
UniversalDashboard.register("mu-backdrop", UDBackdrop);
UniversalDashboard.register("mu-hidden", UDHidden);

// Framework Support
import UdPage from './framework/ud-page';
import UDModal from './framework/ud-modal';
import UdFooter from './framework/ud-footer';

function getDefaultHomePage(pages) {
    return pages.find(function (page) {
        return page.defaultHomePage === true;
    });
}

function redirectToHomePage(pages) {

    if (pages == null || pages.length == 0)
    {
        window.location.href = "/login/unauthorized"
    }

    var defaultHomePage = getDefaultHomePage(pages);

    if (defaultHomePage == null) {
        defaultHomePage = pages[0];
    }

    if (defaultHomePage.url != null && defaultHomePage.url.indexOf(":") === -1) {
        return <Redirect to={defaultHomePage.url} />
    }
    else {
        return <Suspense fallback={<div></div>}>
            <UDErrorCard message="Your first page needs page without a variable in the URL." />
        </Suspense>
    }
}

const intersection = (arr1, arr2) => {
    const res = [];
    const { length: len1 } = arr1;
    const { length: len2 } = arr2;
    const smaller = (len1 < len2 ? arr1 : arr2).slice();
    const bigger = (len1 >= len2 ? arr1 : arr2).slice();
    for(let i = 0; i < smaller.length; i++){
       if(bigger.indexOf(smaller[i]) !== -1){
          res.push(smaller[i]);
          bigger.splice(bigger.indexOf(smaller[i]), 1, undefined);
       }
    };
    return res;
 };

const MaterialUI = (props) => {
    var { dashboard, roles, user, windowsAuth } = props;

    var authedPages = dashboard.pages.filter(x => {
        if (!x.role) return true;
        if (!Array.isArray(x.role)) return true;
        if (!roles || roles.length == 0) return false; 
        if (!Array.isArray(roles)) return false; 
        if (intersection(roles, x.role).length == 0) return false; 
        return true;
    });

    var pages = authedPages.map(function (x) {

        if (!x.url) {
            x.url = x.name;
        }

        if (!x.url.startsWith("/")) {
            x.url = "/" + x.url;
        }

        return <Route key={x.url} path={x.url} exact={x.url.indexOf(":") === -1} render={props => (
            <UdPage 
                id={x.id} dynamic={true} 
                {...x} 
                {...props} 
                autoRefresh={x.autoRefresh} 
                refreshInterval={x.refreshInterval} 
                key={props.location.key} 
                disableThemeToggle={dashboard.disableThemeToggle}
                pages={authedPages}
                user={user}
                windowsAuth={windowsAuth}
            />
        )} />
    })

    return [
        <Suspense fallback={<span />}>
            <Switch>
                {pages}
                <Route exact path={`/`} render={() => redirectToHomePage(authedPages)} />
                <Route path={`/`} render={() => <NotFound />} />
            </Switch>
        </Suspense>,
        <Suspense fallback={<div></div>}>
            <UDModal />
        </Suspense>
    ]
}

UniversalDashboard.onSessionTimedOut = () => { 
    UniversalDashboard.disableFetchService();
    UniversalDashboard.publish('modal.open', {
        content: [<div id="sessionTimedOut">Your session has timed out</div>],
        footer: [<Button onClick={() => window.location.reload()}>Refresh Page</Button>]
    })
}

UniversalDashboard.renderDashboard = (props) => <MaterialUI {...props} />;