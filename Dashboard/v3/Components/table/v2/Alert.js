import React from 'react'
import { Alert, AlertTitle } from '@material-ui/lab'

export default function AlertCard({ error }) {
	return (
		<Alert severity='error'>
			<AlertTitle>Error</AlertTitle>
			{error.message}
		</Alert>
	)
}
