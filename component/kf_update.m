function kf_params = kf_update(kf_params, z)

    if ~isequal(size(kf_params.H, 1), size(z, 1)) || ...
            ~isequal(1, size(z, 2))
        error("kalman filter:input error");
    else
        kf_params.z = z;
    end

    x_ = kf_params.A * kf_params.x + kf_params.B * kf_params.u;
    P_ = kf_params.A * kf_params.P * kf_params.A' + kf_params.Q;
    kf_params.K = P_ * kf_params.H' * (kf_params.H * P_ * kf_params.H' + kf_params.R)^ - 1;
    kf_params.x = x_ + kf_params.K * (kf_params.z - kf_params.H * x_);
    kf_params.P = P_ - kf_params.K * kf_params.H * P_;
end
