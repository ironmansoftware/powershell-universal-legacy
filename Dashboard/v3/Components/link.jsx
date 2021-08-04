import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Link from '@material-ui/core/Link';
import classNames from 'classnames'
import { withComponentFeatures } from 'universal-dashboard'

const useStyles = makeStyles(theme => {
	link: {
		margin: theme.spacing.unit
	}
});

const UDLink = (props) => {
	const classes = useStyles();

	const {
		id,
		url,
		underline,
		style,
		variant,
		className,
		openInNewWindow,
		content,
		text,
		onClick
	} = props;

	return (
		<Link
			id={id}
			href={onClick ? ":" : url}
			rel="noopener"
			underline={underline}
			style={{ ...style }}
			variant={variant}
			className={classNames(className,classes.link, "ud-mu-link")}
			target={openInNewWindow ? '_blank' : '_self'}
			onClick={(e) => {
				if (onClick)
				{
					e.preventDefault();
					onClick();
				}
			}}>
			{!text ? (UniversalDashboard.renderComponent(content)) : text}
		</Link>
	)
}

export default withComponentFeatures(UDLink);
