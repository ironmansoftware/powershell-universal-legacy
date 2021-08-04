import React from "react";
import { fade, makeStyles } from "@material-ui/core/styles";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import InputBase from "@material-ui/core/InputBase";
import SearchIcon from "@material-ui/icons/Search";
import { useState } from "react";
import ExportButton from "../exportButton";
import GlobalFilter from "./globalFilter";

const useStyles = makeStyles((theme) => ({
  grow: {
    flexGrow: 1,
  },
  menuButton: {
    marginRight: theme.spacing(2),
  },
  title: {
    display: "none",
    [theme.breakpoints.up("sm")]: {
      display: "block",
    },
  },
  actions: {
    display: "flex",
    justifyContent: "space-between",
    width: "100%",
    // backgroundColor: '#141414'
  },
  actionsRight: {
    display: "inline-flex",
    alignItems: "center",
  },
  search: {
    position: "relative",
    borderRadius: theme.shape.borderRadius,
    backgroundColor: fade(theme.palette.common.white, 0.15),
    "&:hover": {
      backgroundColor: fade(theme.palette.common.white, 0.25),
    },
    marginRight: theme.spacing(2),
    marginLeft: 0,
    width: "100%",
    [theme.breakpoints.up("sm")]: {
      marginLeft: theme.spacing(3),
      width: "auto",
    },
  },
  searchIcon: {
    padding: theme.spacing(0, 2),
    height: "100%",
    position: "absolute",
    pointerEvents: "none",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
  },
  inputRoot: {
    color: "inherit",
  },
  inputInput: {
    padding: theme.spacing(1, 1, 1, 0),
    // vertical padding + font size from searchIcon
    paddingLeft: `calc(1em + ${theme.spacing(4)}px)`,
    transition: theme.transitions.create("width"),
    width: "100%",
    [theme.breakpoints.up("md")]: {
      width: "20ch",
    },
  },
  sectionDesktop: {
    display: "none",
    [theme.breakpoints.up("md")]: {
      display: "flex",
    },
  },
  sectionMobile: {
    display: "flex",
    [theme.breakpoints.up("md")]: {
      display: "none",
    },
  },
}));

export default function TableToolbar({
  title,
  count,
  isVisible,
  showExport,
  showSearch,
  exportData,
  exportFileName,
  setExportFileName,
  preGlobalFilteredRows,
  setGlobalFilter,
  globalFilter,
  textOption,
  exportOption,
  isServerSide,
  icon
}) {
  const classes = useStyles();

  return (
    isVisible && (
      <div className={classes.grow}>
        <Toolbar className={classes.actions}>
          {title && (
            <Typography className={classes.title} variant="h6" noWrap>
              {
                icon && (
                  UniversalDashboard.renderComponent(icon)
                )
              }
              {title}
            </Typography>
          )}
          <div className={classes.actionsRight}>
            {showSearch && (
              <GlobalFilter
                preGlobalFilteredRows={preGlobalFilteredRows}
                globalFilter={globalFilter}
                count={count}
                setGlobalFilter={setGlobalFilter}
                textOption={textOption}
              />
            )}
            {showExport && (
              <ExportButton
                exportData={exportData}
                exportFileName={exportFileName}
                setExportFileName={setExportFileName}
                textOption={textOption}
                exportOption={exportOption}
              />
            )}
          </div>
        </Toolbar>
      </div>
    )
  );
}