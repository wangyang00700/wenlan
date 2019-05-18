/**
 * Created by 59100 on 2019/5/18.
 */
function check_login() {
    var type = "<c:out value='${sessionScope.type}' />";
    if (type == "") {
        return 0;
    }
    else return 1;
}