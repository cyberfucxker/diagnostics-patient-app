import 'package:diagnostics_patient/config/app_config.dart';

const baseUrl = AppConfig.apiBaseUrl;


const pdfBaseUrl = "${AppConfig.storageBaseUrl}sample_report/";
const imageUrl = "${AppConfig.storageBaseUrl}profile/";
const samplePathPdf = "${AppConfig.storageBaseUrl}report/";

const getcategory = "getcategory";
const getOfferList = "get_offer";
// const getpopularpackage = "get_popular_package_list";
const getpopularpackage = "get_package";
const getpackagedetail = "package_detail";
const getParameterDetail = "parameter_detail";
const getProfileDetail = "profile_detail";
const getBookList = "book_filter";
const getMemberList = "get_member_list";
const getCategoryDetail = "category_detail";
// const getCartList = "get_cart";
const getCartListV2 = "get_cart_v2";
const updateCart = "update_cart";
const getAddress = "getaddress";
// const bookNowApi = "booknow";
const bookNowApiV2 = "booknow_v2";
const UpdatePayment = "UpdatePayment";
const updaetCart = "update_cart";
const saveAddress = "saveaddress";
const saveMember = "save_member";
const register = "register";
const deleteMemberApi = "delete_member";
const getBookDetailApi = "book_detail";
const addFeedBack = "add_feedback";
const searchCategory = "serach_category";
const searchDataApi = "search";
const getCity = "get_city";
const getLabs = "get_lab";
const getTestList = "get_test";
// const getTestListDetail = "get_lab_test_package";
const getCoupon = "coupon";
const getWalletAmount = "get_user_wallet";
const getUserByCityApi = "getUsersByCity";
const getTimeSlotApi = "slots";
const getBanner = "banner";
const addHomeVisits = "homevisit_request";
const getHomeVisitLists = "homevisit_get";
const getPrescription = "get_prescription";
const uploadPrescriptions = "upload_prescription";
const requestCallBack = "request_callback";
// const searchSuggestion = "search_suggestion";
const searchSuggestionV2 = "search_suggestion_v2";
const parameterGet = "get_parameters";
const serverBookPayment = "server_book_payment";
const deleteMyAccount = "delete_account";
const getWalletSettingUrl = "getWalletSetting";
// const validateCouponUrl = "applycoupon";
const validateCouponUrlV2 = "applycoupon_v2";
const otpVerifyUrl = "OTP_verify";
const currentDateTime = "current_date_time";
const getLabByCityName = "getlab_bycityname";

final String SERVER_ADDRESS =
    AppConfig.apiBaseUrl.replaceAll(RegExp(r'/+\$'), '');
const String SERVER_ADDRESS_IMAGE = "${AppConfig.apiBaseUrl}edit_profile";
const String PROFILE_IMAGE_PATH =
    "${AppConfig.storageBaseUrl}profile/";

const String googleApiKey = AppConfig.googleMapsApiKey;
String? palyer_id;

/// Default location (configurable via --dart-define, see AppConfig)
const String defaultCityName = AppConfig.defaultCityName;
const String defaultSlug = AppConfig.defaultCitySlug;
const double defaultLat = AppConfig.defaultLat;
const double defaultLng = AppConfig.defaultLng;
