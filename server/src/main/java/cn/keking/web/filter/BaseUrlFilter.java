package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * @author chenjh
 * @since 2020/5/13 18:27
 */
public class BaseUrlFilter implements Filter {

    private static String BASE_URL;

    public static String getBaseUrl() {
        String baseUrl;
        try {
            baseUrl = (String) RequestContextHolder.currentRequestAttributes().getAttribute("baseUrl", 0);
        } catch (Exception e) {
            baseUrl = BASE_URL;
        }
        return baseUrl;
    }


    @Override
    public void init(FilterConfig filterConfig) {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {

        String baseUrl;
        String configBaseUrl = ConfigConstants.getBaseUrl();

        final HttpServletRequest servletRequest = (HttpServletRequest) request;
        //1、支持通过 http header 中 X-Base-Url 来动态设置 baseUrl 以支持多个域名/项目的共享使用
        final String urlInHeader = servletRequest.getHeader("X-Base-Url");
        if (StringUtils.isNotEmpty(urlInHeader)) {
            baseUrl = urlInHeader;
        } else if (configBaseUrl != null && !ConfigConstants.DEFAULT_VALUE.equalsIgnoreCase(configBaseUrl)) {
            //2、如果配置文件中配置了 baseUrl 且不为 default 则以配置文件为准
            baseUrl = configBaseUrl;
        } else {
            //3、默认动态拼接 baseUrl
            String scheme = servletRequest.getHeader("X-Forwarded-Proto");
            if (StringUtils.isBlank(scheme)) {
                scheme = servletRequest.getHeader("X-Forwarded-Scheme");
            }
            if (StringUtils.isBlank(scheme)) {
                scheme = servletRequest.getHeader("Scheme");
            }
            if (StringUtils.isBlank(scheme)) {
                scheme = servletRequest.getHeader("X-Scheme");
            }
            if (StringUtils.isBlank(scheme)) {
                scheme = request.getScheme();
            }
            // 转换为小写处理可能的大小写差异
            scheme = scheme.toLowerCase();
            // 获取服务器名称
            String serverName = request.getServerName();
            // 处理端口
            int serverPort = request.getServerPort();
            String portString = "";
            if (!("http".equals(scheme) && serverPort == 80) && 
                !("https".equals(scheme) && serverPort == 443)) {
                portString = ":" + serverPort;
            }
            // 拼接 baseUrl
            baseUrl = scheme + "://" + serverName + portString + servletRequest.getContextPath() + "/";
        }

        if (!baseUrl.endsWith("/")) {
            baseUrl = baseUrl.concat("/");
        }

        BASE_URL = baseUrl;
        request.setAttribute("baseUrl", baseUrl);
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
