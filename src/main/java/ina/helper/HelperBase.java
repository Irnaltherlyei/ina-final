package ina.helper;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelperBase {
    protected final HttpServletRequest request;
    protected final HttpServletResponse response;

    public HelperBase(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
    }
}
