//Generated by wsdl2apex

public class AsyncSoapSforceComSchemasClassHmSoupser {
    public class deleteDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassHmSoupser.HM_responseWrapper getValue() {
            soapSforceComSchemasClassHmSoupser.deleteDoctorResponse_element response = (soapSforceComSchemasClassHmSoupser.deleteDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class addDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassHmSoupser.HM_responseWrapper getValue() {
            soapSforceComSchemasClassHmSoupser.addDoctorResponse_element response = (soapSforceComSchemasClassHmSoupser.addDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class updateDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassHmSoupser.HM_responseWrapper getValue() {
            soapSforceComSchemasClassHmSoupser.updateDoctorResponse_element response = (soapSforceComSchemasClassHmSoupser.updateDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class getDoctorsResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassHmSoupser.HM_responseWrapper getValue() {
            soapSforceComSchemasClassHmSoupser.getDoctorsResponse_element response = (soapSforceComSchemasClassHmSoupser.getDoctorsResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncHM_SoupService {
        public String endpoint_x = 'https://eu40.salesforce.com/services/Soap/class/HM_SoupService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public soapSforceComSchemasClassHmSoupser.DebuggingInfo_element DebuggingInfo;
        public soapSforceComSchemasClassHmSoupser.SessionHeader_element SessionHeader;
        public soapSforceComSchemasClassHmSoupser.CallOptions_element CallOptions;
        public soapSforceComSchemasClassHmSoupser.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public soapSforceComSchemasClassHmSoupser.DebuggingHeader_element DebuggingHeader;
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/HM_SoupService';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/HM_SoupService';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/HM_SoupService';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/HM_SoupService';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/HM_SoupService';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/HM_SoupService', 'soapSforceComSchemasClassHmSoupser'};
        public AsyncSoapSforceComSchemasClassHmSoupser.deleteDoctorResponse_elementFuture beginDeleteDoctor(System.Continuation continuation,String id) {
            soapSforceComSchemasClassHmSoupser.deleteDoctor_element request_x = new soapSforceComSchemasClassHmSoupser.deleteDoctor_element();
            request_x.id = id;
            return (AsyncSoapSforceComSchemasClassHmSoupser.deleteDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassHmSoupser.deleteDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'deleteDoctor',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'deleteDoctorResponse',
              'soapSforceComSchemasClassHmSoupser.deleteDoctorResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassHmSoupser.addDoctorResponse_elementFuture beginAddDoctor(System.Continuation continuation,String name,String lastName,String country,String email,String telephoneNumber) {
            soapSforceComSchemasClassHmSoupser.addDoctor_element request_x = new soapSforceComSchemasClassHmSoupser.addDoctor_element();
            request_x.name = name;
            request_x.lastName = lastName;
            request_x.country = country;
            request_x.email = email;
            request_x.telephoneNumber = telephoneNumber;
            return (AsyncSoapSforceComSchemasClassHmSoupser.addDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassHmSoupser.addDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'addDoctor',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'addDoctorResponse',
              'soapSforceComSchemasClassHmSoupser.addDoctorResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassHmSoupser.updateDoctorResponse_elementFuture beginUpdateDoctor(System.Continuation continuation,String id,String name,String lastName,String country,String email,String telephoneNumber) {
            soapSforceComSchemasClassHmSoupser.updateDoctor_element request_x = new soapSforceComSchemasClassHmSoupser.updateDoctor_element();
            request_x.id = id;
            request_x.name = name;
            request_x.lastName = lastName;
            request_x.country = country;
            request_x.email = email;
            request_x.telephoneNumber = telephoneNumber;
            return (AsyncSoapSforceComSchemasClassHmSoupser.updateDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassHmSoupser.updateDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'updateDoctor',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'updateDoctorResponse',
              'soapSforceComSchemasClassHmSoupser.updateDoctorResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassHmSoupser.getDoctorsResponse_elementFuture beginGetDoctors(System.Continuation continuation,String name,String lastName,String email,String country) {
            soapSforceComSchemasClassHmSoupser.getDoctors_element request_x = new soapSforceComSchemasClassHmSoupser.getDoctors_element();
            request_x.name = name;
            request_x.lastName = lastName;
            request_x.email = email;
            request_x.country = country;
            return (AsyncSoapSforceComSchemasClassHmSoupser.getDoctorsResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassHmSoupser.getDoctorsResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'getDoctors',
              'http://soap.sforce.com/schemas/class/HM_SoupService',
              'getDoctorsResponse',
              'soapSforceComSchemasClassHmSoupser.getDoctorsResponse_element'}
            );
        }
    }
}