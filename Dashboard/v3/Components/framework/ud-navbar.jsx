import React, {useState, useEffect} from 'react';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import AccountCircle from '@material-ui/icons/AccountCircle';
import MenuItem from '@material-ui/core/MenuItem';
import Menu from '@material-ui/core/Menu';


import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';

import Drawer from '@material-ui/core/Drawer';

import { withComponentFeatures } from 'universal-dashboard'
import ToggleColorMode from './togglecolormodes.jsx';

const drawerWidth = 250;

const useStyles = makeStyles((theme) => ({
    list: {
      width: drawerWidth,
    },
    fullList: {
      width: 'auto',
    },
    drawer: {
        width: drawerWidth,
        flexShrink: 0,
    },
    grow: {
        flexGrow: 1,
    },
    drawerPaper: {
        width: drawerWidth
    },
    drawerContainer: {
        overflow: 'auto',
    },
    fixedAppBar: {
        zIndex: theme.zIndex.drawer + 1,
      },
  }));

const UdNavbar = (props) => {
    const classes = useStyles();

    const [open, setOpen] = useState(false);
    const [anchorEl, setAnchorEl] = React.useState(null);
    const menuOpen = Boolean(anchorEl);

    const handleMenu = (event) => {
      setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
      setAnchorEl(null);
    };

    const onItemClick = (page) => {
        props.history.push(`/${page.name.replace(/ /g, "-")}`);    
        setOpen(false);
    }
    
    const renderSideNavItem = (item) => {
        var linkText = item.text ? item.text : item.name;
    
        return <ListItem button onClick={() => onItemClick(item)}>
            <ListItemText>{linkText}</ListItemText>
        </ListItem>
    }

    var menuButton = null;
    var drawer = null; 

    if (props.pages.length > 1 && !props.navigation) 
    {
        var links = props.pages.map(function(x, i) {
            if (x.name == null) return null;
            return renderSideNavItem({...x, history: props.history, setOpen: props.setOpen});
        })
    
        drawer = <Drawer 
                    open={open} 
                    onClose={() => setOpen(false)} 
                    variant={props.fixed ? "permanent" : "temporary"} 
                    className={classes.drawer} 
                    classes={{ paper: classes.drawerPaper }}>
            {props.fixed ? <Toolbar /> : <React.Fragment /> }
            <div className={classes.drawerContainer} role="presentation">
                <List>
                    {links}
                </List> 
            </div>
        </Drawer>

        menuButton = props.fixed ? <React.Fragment /> : <IconButton edge="start" color="inherit" aria-label="menu" onClick={() => setOpen(true)} >
            <MenuIcon />
        </IconButton>
    }

    if (props.navigation) {
        drawer = <Drawer 
                    open={open} 
                    onClose={() => setOpen(false)} 
                    variant={props.fixed ? "permanent" : "temporary"} 
                    className={classes.drawer} 
                    classes={{ paper: classes.drawerPaper }}>
                {props.fixed ? <Toolbar /> : <React.Fragment /> }
                <div className={classes.drawerContainer} role="presentation">
                <List>
                    {props.render(props.navigation)}
                </List> 
            </div>
            </Drawer>

        menuButton = props.fixed ? <React.Fragment /> : <IconButton edge="start" color="inherit" aria-label="menu" onClick={() => setOpen(true)} >
            <MenuIcon />
            </IconButton>
    }

    var children = null;
    if (props.children)
    {
        children = props.render(props.children);
    }

    const logout = () => {
        UniversalDashboard.get('/api/v1/signout', () => {
            window.location.href = '/login?ReturnUrl=' + window.location.pathname
        });
    };

    return [
        <AppBar position={props.fixed ? "fixed" : "static"} className={props.fixed ? classes.fixedAppBar : ""}>
            <Toolbar>
                {menuButton}
                {props.logo && <img src={props.logo} id="ud-logo" style={ {paddingRight: '10px'} }/>}
                <Typography variant="h6">
                    {props.title}
                </Typography>
                <div className={classes.grow} />
                {children}  
                {props.disableThemeToggle ? <React.Fragment/> : <ToggleColorMode/>}
                {!props.windowsAuth && props.user && props.user !== '' && (<>
                    <IconButton
                    aria-label="account of current user"
                    aria-controls="menu-appbar"
                    aria-haspopup="true"
                    onClick={handleMenu}
                    color="inherit"
                    >
                        <AccountCircle />
                        <Typography variant="h6" style={{paddingLeft: "10px"}}>{props.user}</Typography>
                    </IconButton>
                    <Menu
                        id="menu-appbar"
                        anchorEl={anchorEl}
                        anchorOrigin={{
                        vertical: 'top',
                        horizontal: 'right',
                        }}
                        keepMounted
                        transformOrigin={{
                        vertical: 'top',
                        horizontal: 'right',
                        }}
                        open={menuOpen}
                        onClose={handleClose}
                    >
                        <MenuItem onClick={logout}>Logout</MenuItem>
                    </Menu>
                </>)}
            </Toolbar>
        </AppBar>,
        drawer
    ]
}

export default withComponentFeatures(UdNavbar);