import { MenuItem, ButtonProps, Typography, Box } from '@mui/material';
import PublicShareSwitch from 'components/Collections/CollectionShare/publicShare/switch';
import {
    FluidContainer,
    HorizontalFlex,
    SpaceBetweenFlex,
} from 'components/Container';
import { DotSeparator } from 'components/Sidebar/styledComponents';
import React from 'react';

interface Iprops {
    onClick: () => void;
    color?: ButtonProps['color'];
    startIcon?: React.ReactNode;
    endIcon?: React.ReactNode;
    subText?: string;
    children?: any;
    hasSwitch?: boolean;
    checked?: boolean;
}
export function EnteMenuItem({
    onClick,
    color = 'primary',
    startIcon,
    endIcon,
    subText,
    children,
    hasSwitch = false,
    checked,
}: Iprops) {
    const handleClick = () => {
        onClick();
    };
    return (
        <MenuItem
            onClick={handleClick}
            sx={{
                minWidth: '220px',
                color: (theme) => theme.palette[color].main,
                backgroundColor: (theme) => theme.colors.background.elevated2,
                padding: 2,
                '& .MuiSvgIcon-root': {
                    fontSize: '20px',
                },
                borderRadius: '8px',
            }}>
            <SpaceBetweenFlex>
                <HorizontalFlex>
                    {startIcon && (
                        <Box
                            sx={{
                                padding: 0,
                                marginRight: 1.5,
                            }}>
                            {startIcon}
                        </Box>
                    )}
                    <Typography fontWeight="bold">{children}</Typography>

                    {subText && (
                        <FluidContainer
                            sx={{
                                color: 'text.muted',
                                fontSize: '14px',
                            }}>
                            <DotSeparator style={{ fontSize: 8 }} />

                            {subText}
                        </FluidContainer>
                    )}
                </HorizontalFlex>
                <HorizontalFlex>
                    {endIcon && (
                        <Box
                            sx={{
                                marginLeft: 1,
                            }}>
                            {endIcon}
                        </Box>
                    )}
                    {hasSwitch && (
                        <PublicShareSwitch
                            checked={checked}
                            onChange={handleClick}
                        />
                    )}
                </HorizontalFlex>
            </SpaceBetweenFlex>
        </MenuItem>
    );
}
