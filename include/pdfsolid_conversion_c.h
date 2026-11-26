#ifndef PDFSOLID_CONVERSION_C_H
#define PDFSOLID_CONVERSION_C_H

#if _WIN32
#include <windows.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#include "pdfsolid_basictypes_c.h"

#define CPDF_WORD_TO_PDF_DIAGNOSTICS_SIZE 8192

/// \brief Starts the conversion of a PDF file to a Word document.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted Word document will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToWord(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a Word document to a PDF file.
///
/// \param[in] file_path Path to the input Word document.
/// \param[in] output_path Path where the converted PDF file will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion; start from CPDF_CONVERT_OPTION_DEFAULT. Word to PDF uses page_ranges and word_pdf_bookmark_mode; the other fields do not apply.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \param[out] diagnostics Optional caller-owned buffer of CPDF_WORD_TO_PDF_DIAGNOSTICS_SIZE bytes. The buffer receives UTF-8 diagnostics and is not allocated or freed by the SDK. Pass NULL if diagnostics are not needed.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
/// e_CErrUnsupportedFeature if the document uses features that may affect fidelity; the PDF is usually still produced,
/// and the first diagnostics line is "output=produced" or "output=not_produced".
/// e_CErrOutOfMemory if the diagnostics buffer cannot hold the complete diagnostics.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartWordToPDF(PDFSOLID_STRING file_path, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback, char* diagnostics);

/// \brief Starts the conversion of a PDF file to an RTF document.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted RTF document will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToRtf(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to an Excel document.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted Excel document will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToExcel(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to a PowerPoint presentation.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted PowerPoint presentation will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToPpt(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to an HTML document.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted HTML document will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToHtml(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to an image format.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted images will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToImage(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to a searchable PDF.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the searchable PDF will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToSearchablePDF(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to a plain text file.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted text file will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToTxt(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to a JSON file.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted JSON file will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToJson(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to a Markdown file.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted Markdown file will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToMarkdown(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

/// \brief Starts the conversion of a PDF file to an OFD document.
///
/// \param[in] file_path Path to the input PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \param[in] output_path Path where the converted OFD document will be saved.
/// \param[in] options \link CConvertOption \endlink settings for conversion.
/// \param[in] callback Optional \link CConvertCallback \endlink function for handling convert operations.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the operation.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_StartPDFToOfd(PDFSOLID_STRING file_path, PDFSOLID_STRING password, PDFSOLID_STRING output_path, CConvertOption options, CConvertCallback* callback);

#ifdef __cplusplus
}

#endif

#endif //PDFSOLID_CONVERSION_C_H
