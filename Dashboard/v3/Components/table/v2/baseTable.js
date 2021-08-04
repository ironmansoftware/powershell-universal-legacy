import React from "react";
import Paper from "@material-ui/core/Paper";
import Table from "@material-ui/core/Table";
import TableContainer from "@material-ui/core/TableContainer";
import { useExportData } from "react-table-plugins";
import { getExportFileBlob, normalizedData, downloadFileViaBlob } from "./utilities";
import { SelectAllCheckBox, SelectCheckBox } from "./columns";
import { DefaultColumnFilter, fuzzyTextFilterFn } from "./filters";
import TableToolbar from "./toolbar";
import useFetchData from "./hooks/useFetchData";
import BaseTableBody from "../components/baseTableBody";
import BaseTableHead from "../components/baseTableHead";
import BaseTableFooter from "../components/baseTableFooter";
import {
  useTable,
  useSortBy,
  useFilters,
  useGlobalFilter,
  usePagination,
  useRowSelect,
} from "react-table";

// Create a default prop getter
// const defaultPropGetter = () => ({})


export default function TableBase({
  data,
  columns,
  sortColumn,
  isServerSide,
  // getCellProps = defaultPropGetter,
  ...restOfProps
}) {

  const [fileName, setFileName] = React.useState(() => "");
  const [exporting, setExporting] = React.useState(false);

  const filterTypes = {
    search: fuzzyTextFilterFn,
  };

  const [staticData, setStaticData] = React.useState(
    React.useMemo(() => normalizedData(data), [])
  );

  React.useEffect(() => {
    setStaticData(normalizedData(data));
  }, [data]);

  const {
    data: tableData,
    pageCount: pCount,
    skipPageReset,
    total: tCount,
    loading,
    onFetchData,
  } = useFetchData({
    loadData: restOfProps?.loadData,
  });

  const getTotalCount = () => {
    return isServerSide ? tCount : (flatRows ? flatRows.length : 0);
  };

  const getExportFileName =  () => `${fileName || restOfProps?.title || 'data'}`

  const exportDataServerSide = (type, all) => {
    if (restOfProps?.onExport)
    {
      setExporting(true);
       restOfProps.onExport({
          filters,
          pageSize,
          page: pageIndex,
          search: globalFilter,
          orderBy: sortBy[0]?.id ? { field: sortBy[0]?.id } : {},
          orderDirection: sortBy[0]?.desc ? "desc" : "asc",
          properties: columns.map((column) => column.accessor),
          allRows: all
        }).then(data => {
          setExporting(false);
          const blob = getExportFileBlob({
            columns: columns.map((c) => ({...c, exportValue: c.accessor})), 
            fileName: getExportFileName(),
            fileType: type, 
            data: JSON.parse(data)
          });
          downloadFileViaBlob(blob, getExportFileName(), type)
        });
    }
  }

  var sortByCols = [];
  if (restOfProps?.defaultSortDirection && restOfProps?.defaultSortDirection !== '')
  {
    sortByCols.push({
      id: sortColumn,
      desc: restOfProps?.defaultSortDirection === "descending",
    })
  }

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    prepareRow,
    page,
    rows,
    gotoPage,
    setPageSize,
    preGlobalFilteredRows,
    setGlobalFilter,
    flatRows,
    exportData,
    visibleColumns,
    selectedFlatRows,
    state: {
      pageIndex,
      pageSize,
      sortBy,
      filters,
      selectedRowIds,
      globalFilter,
    },
    toggleAllRowsSelected,
  } = useTable(
    {
      data: isServerSide ? tableData : staticData,
      columns: columns,
      defaultColumn: {
        Cell: ({ cell: { value, column, row } }) => {
          if (column?.cellRenderer === null) {
            if (!value) return null;
            return value;
          } else {
            return restOfProps.render(row.original[`rendered${column.id}`]);
          }
        },
        Filter: DefaultColumnFilter,
      },
      filterTypes,
      initialState: {
        pageIndex: 0,
        pageSize: (restOfProps?.showPagination || restOfProps?.loadData) ? (restOfProps?.userPageSize || 10) : staticData.length,
        sortBy: sortByCols,
        hiddenColumns: [restOfProps.showSelection ? null : "selection"],
      },
      manualPagination: isServerSide,
      manualGlobalFilter: isServerSide,
      manualFilters: isServerSide,
      manualSortBy: isServerSide,
      autoResetPage: !skipPageReset,
      autoResetFilters: !skipPageReset,
      autoResetSortBy: !skipPageReset,
      autoResetSelectedRows: !skipPageReset,
      pageCount: isServerSide ? pCount : -1,
      getRowId: (row, index) => (isServerSide ? `${row.uid}` : index),
      onRowSelection: restOfProps.onRowSelection,
      getExportFileBlob,
      getExportFileName,
      sortTypes: {
          alphanumeric: (row1, row2, columnName) => {
              const rowOneColumn = row1.values[columnName];
              const rowTwoColumn = row2.values[columnName];
              if (isNaN(rowOneColumn)) {
                  return rowOneColumn.toUpperCase() >
                      rowTwoColumn.toUpperCase()
                      ? 1
                      : -1;
              }
              return Number(rowOneColumn) > Number(rowTwoColumn) ? 1 : -1;
          }
      },
      textOption: restOfProps?.textOption,
      rowCount: getTotalCount(),
      disableSortRemove: restOfProps.disableSortRemove
    },
    useGlobalFilter,
    useFilters,
    restOfProps?.showSort ? useSortBy : () => {},
    usePagination,
    useRowSelect,
    useExportData,
    (hooks) => {
      hooks.allColumns.push((columns) => [
        {
          id: "selection",
          Header: ({ getToggleAllRowsSelectedProps }) => (
            restOfProps?.hideToggleAllRowsSelected || restOfProps?.disableMultiSelect ? <React.Fragment /> : <SelectAllCheckBox {...getToggleAllRowsSelectedProps()} onRowSelection={restOfProps?.onRowSelection}/> 
          ),
          Cell: ({ row }) => (
            <SelectCheckBox
              {...row.getToggleRowSelectedProps()}
              row={row}
              singleSelection={restOfProps?.disableMultiSelect}
              onRowSelection={restOfProps?.onRowSelection}
              toggleAllRowsSelected={toggleAllRowsSelected}
            />
          ),
        },
        ...columns,
      ]);
    }
  );

  React.useEffect(() => {
    if (isServerSide) {
      onFetchData({
        filters,
        pageSize,
        page: pageIndex,
        search: globalFilter,
        orderBy: sortBy[0]?.id ? { field: sortBy[0]?.id } : {},
        orderDirection: sortBy[0]?.desc ? "desc" : "asc",
        properties: columns.map((column) => column.accessor),
      });
    }
  }, [onFetchData, pageIndex, pageSize, sortBy, filters, globalFilter]);

  React.useEffect(() => {
    const selectedRows = selectedFlatRows.map((row) => row.original);
    restOfProps?.setState({ selectedRows });
  }, [selectedRowIds]);

  return (
    <TableContainer component={Paper} >
      <TableToolbar
        isVisible={
          restOfProps?.title || restOfProps?.showExport || restOfProps?.showSearch
        }
        count={getTotalCount()}
        icon={restOfProps?.icon}
        title={restOfProps?.title}
        textOption={restOfProps?.textOption}
        exportOption={restOfProps?.exportOption}
        showExport={restOfProps?.showExport}
        showSearch={restOfProps?.showSearch}
        exportData={restOfProps?.onExport ? exportDataServerSide : exportData}
        exportFileName={fileName}
        globalFilter={globalFilter}
        preGlobalFilteredRows={preGlobalFilteredRows}
        setExportFileName={setFileName}
        setGlobalFilter={setGlobalFilter}
      />
      <Table
        {...getTableProps()}
        id={restOfProps?.id}
        size={restOfProps?.isDense ? "small" : "medium"}
      >
        <BaseTableHead headerGroups={headerGroups} columns={columns} />
        <BaseTableBody
          getTableBodyProps={getTableBodyProps}
          // getCellProps={getCellProps}
          pageIndex={pageIndex}
          pageSize={restOfProps?.showPagination ? pageSize : getTotalCount()}
          prepareRow={prepareRow}
          visibleColumns={visibleColumns}
          totalData={isServerSide ? tCount : rows?.length}
          page={page}
          isDense={restOfProps?.isDense}
        />
        <BaseTableFooter
          {...restOfProps}
          gotoPage={gotoPage}
          setPageSize={setPageSize}
          colSpan={visibleColumns.length}
          count={getTotalCount()}
          pageSize={pageSize}
          pageIndex={pageIndex}
          userPageSize={restOfProps.userPageSize}
          isVisible={restOfProps?.showPagination}
          userPageSizeOptions={restOfProps.userPageSizeOptions}
          disablePageSizeAll={restOfProps.disablePageSizeAll}
          loading={loading || exporting}
        />
      </Table>
    </TableContainer>
  );
}