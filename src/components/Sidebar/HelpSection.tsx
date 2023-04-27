import React, { useContext, useState } from 'react';
import { t } from 'i18next';

import ExportModal from 'components/ExportModal';
import exportService from 'services/export';
import { getEndpoint } from 'utils/common/apiUtil';
import { getToken } from 'utils/common/key';
import isElectron from 'is-electron';
import { AppContext } from 'pages/_app';
import EnteSpinner from 'components/EnteSpinner';
import { getDownloadAppMessage } from 'utils/ui';
import { NoStyleAnchor } from 'components/pages/sharedAlbum/GoToEnte';
import { openLink } from 'utils/common';
import { EnteMenuItem } from 'components/Menu/EnteMenuItem';
import { Typography } from '@mui/material';

export default function HelpSection() {
    const [exportModalView, setExportModalView] = useState(false);

    const { setDialogMessage } = useContext(AppContext);

    function openFeedbackURL() {
        const feedbackURL: string = `${getEndpoint()}/users/feedback?token=${encodeURIComponent(
            getToken()
        )}`;
        openLink(feedbackURL, true);
    }

    function openExportModal() {
        if (isElectron()) {
            setExportModalView(true);
        } else {
            setDialogMessage(getDownloadAppMessage());
        }
    }

    return (
        <>
            <EnteMenuItem
                onClick={openFeedbackURL}
                label={t('REQUEST_FEATURE')}
                variant="secondary"
            />
            <EnteMenuItem
                onClick={() => openLink('mailto:contact@ente.io', true)}
                labelComponent={
                    <NoStyleAnchor href="mailto:contact@ente.io">
                        <Typography fontWeight={'bold'}>
                            {t('SUPPORT')}
                        </Typography>
                    </NoStyleAnchor>
                }
                variant="secondary"
            />
            <EnteMenuItem
                onClick={openExportModal}
                label={t('EXPORT')}
                endIcon={
                    exportService.isExportInProgress() && (
                        <EnteSpinner size="20px" />
                    )
                }
                variant="secondary"
            />
            <ExportModal
                show={exportModalView}
                onHide={() => setExportModalView(false)}
            />
        </>
    );
}
