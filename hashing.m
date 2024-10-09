function [hashes] = hashing(filename)
[peak_magnitudes, spec_f, spec_t, fs, window] = getConstellation(filename);
[reduced_constellation, spec_t, fs] = getReducedConstellation(peak_magnitudes, spec_f, spec_t, fs, window);
[hashes] = getHashes(reduced_constellation, spec_t, spec_f);
end

