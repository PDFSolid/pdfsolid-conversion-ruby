#ifndef PDFSOLID_COMMON_C_H
#define PDFSOLID_COMMON_C_H

#if _WIN32
#include <windows.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>

#include "pdfsolid_basictypes_c.h"

/// \brief Verifies the license for using the PDFSolid Conversion SDK.
///
/// \param[in] license The license key string provided by PdfSolidConversion.
/// \param[in] device_id Unique identifier of the device on which the SDK will be used.
/// \param[in] app_id Application ID associated with the license.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of the license verification process.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_LicenseVerify(const char* license, const char* device_id, const char* app_id);

/// \brief Returns the currently verified license type.
/// Returns e_CLicenseUnknown before verification, after failed verification,
/// or while releasing. Does not consume quota or verify the license again.
PDFSOLID_DECL
CLicenseType CSDK_PDFSOLID_CALL CPDF_GetLicenseType();

/// \brief Initializes the SDK with the specified resource path.
///
/// \param[in] resource_path Path to the resources required by the SDK.
PDFSOLID_DECL
void CSDK_PDFSOLID_CALL CPDF_Initialize(PDFSOLID_STRING resource_path);

/// \brief Configures logging settings for the SDK.
///
/// When both flags are false, only error messages are logged.
/// \param[in] enable_info If true, enables info level logging (info, warning and error messages).
/// \param[in] enable_warning If true and enable_info is false, enables warning level logging (warning and error messages).
PDFSOLID_DECL
void CSDK_PDFSOLID_CALL CPDF_SetLogger(bool enable_info, bool enable_warning);

/// \brief Merges DocumentAI components from a model package used for advanced processing like OCR.
/// \pre Stop new SDK calls and join all active conversion/inference callers
/// before configuring or reloading models; lifecycle calls must be serialized.
///
/// Each call loads only the capabilities contained in the given model package and
/// merges them with the capabilities already loaded; it does not replace them.
/// If a package fails to load, the capabilities loaded before are kept.
///
/// \param[in] model_path Path to the model package file, e.g. "documentai.model".
/// \param[in] gpu_id Index of the GPU used by the AI model. -1 disables GPU.
/// \return \link CSDKErrorCode \endlink indicating the success or failure of loading the model package.
/// e_CErrInvalidArg if model_path is empty; e_CErrConverting while conversion tasks
/// are running or a release is pending.
PDFSOLID_DECL
CSDKErrorCode CSDK_PDFSOLID_CALL CPDF_SetDocumentAIModel(
    PDFSOLID_STRING model_path, int gpu_id);

/// \brief Retrieves the number of pages in a given PDF file.
///
/// \param[in] file_path Path to the PDF file.
/// \param[in] password Password for opening the PDF file (if required).
/// \return The number of pages in the PDF file; 0 if the file cannot be opened
/// (for example, a wrong password); -1 while library resources are being released or configured.
PDFSOLID_DECL
int CSDK_PDFSOLID_CALL CPDF_GetPageCount(PDFSOLID_STRING file_path, PDFSOLID_STRING password);

/// \brief Returns the remaining page quota.
/// \return >= 0: actual remaining pages, -1: not initialized,
///         -2: unlimited, -3: quota file corrupted.
PDFSOLID_DECL
int CSDK_PDFSOLID_CALL CPDF_GetRemainingPageQuota();

/// \brief Retrieves the version of the PDFSolid Conversion SDK.
///
/// \param[out] version Caller-allocated buffer that receives the null-terminated
/// version string, e.g. "1.3.0". It must be large enough for the string, e.g. 32 bytes.
PDFSOLID_DECL
void CSDK_PDFSOLID_CALL CPDF_GetVersion(char* version);

/// \brief Releases all resources and cleans up the SDK.
/// If synchronous conversion tasks are still running, cleanup is deferred until
/// the last one returns; new tasks are refused meanwhile.
/// \pre Stop new SDK calls and join all active callers before releasing resources.
PDFSOLID_DECL
void CSDK_PDFSOLID_CALL CPDF_Release();

/// \brief Release the memory by the AI model. If you want to use the AI function again after this call, you need to call the \link CPDF_SetDocumentAIModel \endlink interface again.
/// \pre Stop new SDK calls and join all conversion/inference callers first.
/// This function does not cancel in-flight or queued inference.
PDFSOLID_DECL
void CSDK_PDFSOLID_CALL CPDF_ReleaseDocumentAIModel();

/// \brief Sets the number of AI models for layout analysis and table recognition.
/// \pre Call before inference starts, or after stopping and joining all callers.
/// The call is ignored while conversion tasks are running or a release is pending.
///
/// \param[in] layout_model_count Number of layout analysis models to be used.
/// \param[in] table_model_count Number of table recognition models to be used.
PDFSOLID_DECL
void CSDK_PDFSOLID_CALL CPDF_SetDocumentAIModelCount(int layout_model_count, int table_model_count);

#ifdef __cplusplus
}
#endif

#endif //PDFSOLID_COMMON_C_H
